import xml.etree.ElementTree as ET
import mysql.connector

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="NutBars@1129$",
    database="airline_db"
)

mycursor = mydb.cursor()

def insert_data_from_xml(xml_filepath, table_name):
    try:
        tree = ET.parse(xml_filepath)
        root = tree.getroot()

        first_row = root.find('row')
        if first_row is not None:
            xml_columns = [element.tag for element in first_row]
            print(f"Columns in XML: {xml_columns}")

            mycursor.execute(f"DESCRIBE {table_name}")
            mysql_columns = {row[0]: row[1] for row in mycursor.fetchall()}
            print(f"Columns in MySQL: {mysql_columns}")
        else:
            print("No <row> elements found in XML.")
            return False

        for row in root.findall('row'):
            try:
                columns = ", ".join(f"`{element.tag}`" for element in row)
                values = []
                for element in row:
                    value = element.text
                    if value is None or value == "" or str(value).lower() == "null":  # Handle missing values
                        values.append("NULL")
                    elif isinstance(value, str):
                        values.append(f"'{value.replace('\'', '\\\'')}'")  # Escape quotes
                    else:
                        values.append(str(value))  # Convert other data types to strings

                values_str = ", ".join(values)
                sql = f"INSERT INTO `{table_name}` ({columns}) VALUES ({values_str});"
                print(f"Executing SQL: {sql}")
                mycursor.execute(sql)
                print("Row inserted successfully (if no error occurs)")

            except mysql.connector.Error as err:
                print(f"MySQL Error inserting row into {table_name}: {err}")
                print(f"SQL Query: {sql}")
                print(f"Problematic row: {ET.tostring(row, encoding='unicode')}")
                mydb.rollback()
                return False
            except Exception as e:
                print(f"Error inserting row into {table_name}: {e}")
                print(f"SQL Query: {sql}")
                print(f"Problematic row: {ET.tostring(row, encoding='unicode')}")
                mydb.rollback()
                return False

        mydb.commit()
        print(f"Data from {xml_filepath} inserted into {table_name} successfully.")
        return True

    except FileNotFoundError:
        print(f"Error: XML file not found at {xml_filepath}")
        return False
    except ET.ParseError as e:
        print(f"Error parsing XML file {xml_filepath}: {e}")
        return False
    except Exception as e:
        print(f"Error reading or processing XML file: {e}")
        mydb.rollback()
        return False

# --- Example Usage --- 
xml_file = r"path\db_suppliers.xml"  # Your XML file path
table = "suppliers"  # Your MySQL table name

if insert_data_from_xml(xml_file, table):
    print("Import process completed.")
else:
    print("Import process failed. Check the error messages above.")

mydb.close()