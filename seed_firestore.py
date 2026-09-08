import json
import os
import firebase_admin
from firebase_admin import credentials, firestore

def main():
    # 1. Define file paths
    CREDENTIALS_FILE = 'service_account.json'
    DATA_FILE = 'my_projects.json'

    # Verify the service account key exists
    if not os.path.exists(CREDENTIALS_FILE):
        print(f"Error: '{CREDENTIALS_FILE}' not found.")
        print("Please download it from the Firebase Console and place it in this directory.")
        return

    # 2. Initialize Firebase Admin SDK
    print("Authenticating with Firebase...")
    cred = credentials.Certificate(CREDENTIALS_FILE)
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    print("Authenticated successfully.\n")

    # 3. Load the JSON data
    print(f"Reading '{DATA_FILE}'...")
    try:
        with open(DATA_FILE, 'r') as file:
            database_schema = json.load(file)
    except FileNotFoundError:
        print(f"Error: '{DATA_FILE}' not found.")
        return
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON formatting in '{DATA_FILE}'.\nDetails: {e}")
        return

    # 4. Write data to Firestore
    print("Pushing data to Cloud Firestore...")
    
    # Iterate over the top-level keys (which map to our Firestore collections)
    for collection_name, documents in database_schema.items():
        print(f"\nProcessing collection: '{collection_name}'")
        
        # Iterate over the documents within the collection
        for doc_id, doc_data in documents.items():
            doc_ref = db.collection(collection_name).document(doc_id)
            
            # Using merge=True ensures we update existing fields and add new ones 
            # without wiping out the entire document if it already exists.
            doc_ref.set(doc_data, merge=True)
            print(f"Wrote document: '{doc_id}'")

    print("\nExecution Complete. All data successfully synced to Firestore.")

if __name__ == "__main__":
    main()