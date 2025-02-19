import csv
import json
import xml.etree.ElementTree as ET
import mysql.connector
from datetime import datetime

# --- MySQL Connection Details --- (REPLACE THESE WITH YOUR ACTUAL DETAILS)
mydb = mysql.connector.connect(
    host="your_host",
    user="your_user",
    password="your_password",
    database="your_database"
)

mycursor = mydb.cursor()

def import_data(filepath, table_name, date_format="%Y-%m-%d %H:%M:%S"):
    """Imports data from CSV, JSON, or XML into a MySQL table."""

    try:
        # 1. Determine file type
        if filepath.endswith('.csv'):
            return import_from_csv(filepath, table_name, date_format)
        elif filepath.endswith('.json'):
            return import_from_json(filepath, table_name, date_format)
        elif filepath.endswith('.xml'):
            return import_from_xml(filepath, table_name, date_format)
        else:
            print(f"Error: Unsupported file type for {filepath}")
            return False

    except Exception as e:
        print(f"General error: {e}")
        mydb.rollback()
        return False


def import_from_csv(csv_filepath, table_name, date_format):
    # ... (CSV import code - same as the most recent CSV version you have)

def import_from_json(json_filepath, table_name, date_format):
    # ... (JSON import code - same as the most recent JSON version you have)

def import_from_xml(xml_filepath, table_name, date_format):
    """Imports data from an XML file into a MySQL table."""
    try:
        tree = ET.parse(xml_filepath)
        root = tree.getroot()

        # --- Column Name Checking ---
        print(f"Target table: {table_name}")
        # Get column names from the first record (assuming consistent structure)
        first_record = root[0] # Get the first element which is assumed to be a record
        json_keys = [element.tag for element in first_record] # Get the tag of each element which is the key
        print(f"Keys in XML: {json_keys}")
        mycursor.execute(f"DESCRIBE {table_name}")
        mysql_columns = {row[0]: row[1] for row in mycursor.fetchall()}
        print(f"Columns in MySQL: {mysql_columns}")

        for record in root:  # Iterate through each record (e.g., <row> elements)
            row = {}
            for element in record: # Iterate through each element in the record
                row[element.tag] = element.text # Add the element's tag and text into the row dictionary
            try:
                columns = ", ".join(f"`{col}`" for col in row.keys())
                values = []
                for key, value in row.items():
                    # ... (Date/time handling, NULL handling, type conversion - same as JSON version)

                values_str = ", ".join(values)
                sql = f"INSERT INTO `{table_name}` ({columns}) VALUES ({values_str});"
                print(f"Executing SQL: {sql}")
                mycursor.execute(sql)
                print("Row inserted successfully (if no error occurs)")

            except mysql.connector.Error as err:
                # ... (Error handling - same as JSON version)
            except Exception as e:
                # ... (Error handling - same as JSON version)

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
filepath = r"path/to/your/data.csv"  # Or .json or .xml
table = "your_table_name"
date_format = "%Y-%m-%d %H:%M:%S"  # Or whatever is appropriate

if import_data(filepath, table, date_format):
    print("Data imported successfully.")
else:
    print("Data import failed. Check the error messages above.")

mydb.close()