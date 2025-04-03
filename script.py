import os
import pandas as pd
import psycopg2
from psycopg2 import sql

# Paramètres de connexion à PostgreSQL
DB_PARAMS = {
    "dbname": "olist_db",
    "user": "anyes",
    "password": "olist_db0304",
    "host": "localhost",
    "port": "5432"
}

# Répertoire où se trouvent les fichiers CSV
CSV_FOLDER = "olist_dataset"

# Liste des fichiers CSV et des tables correspondantes, sans le préfixe 'olist_'
TABLES_CSV_MAPPING = {
    "customers": "olist_customers_dataset.csv",
    "geolocation": "olist_geolocation_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "order_payments": "olist_order_payments_dataset.csv",
    "order_reviews": "olist_order_reviews_dataset.csv",
    "orders": "olist_orders_dataset.csv",
    "products": "olist_products_dataset.csv",
    "sellers": "olist_sellers_dataset.csv",
    "product_category_name_translation": "product_category_name_translation.csv",
    "leads_closed": "leads_closed.csv",
    "leads_qualified": "leads_qualified.csv"
}

# Connexion à la base de données
def connect_db():
    try:
        conn = psycopg2.connect(**DB_PARAMS)
        print("Connexion à PostgreSQL réussie !")
        return conn
    except Exception as e:
        print("Erreur de connexion :", e)
        return None

# Fonction pour insérer un fichier CSV dans une table PostgreSQL
def insert_csv_to_db(table_name, csv_file, conn):
    file_path = os.path.join(CSV_FOLDER, csv_file)
    
    if not os.path.exists(file_path):
        print(f"Fichier introuvable : {file_path}")
        return
    
    print(f"Insertion des données dans {table_name} depuis {csv_file}...")

    try:
        # Lire le fichier CSV en corrigeant les NaN et les erreurs de colonnes
        df = pd.read_csv(file_path, na_values=["NaN"])
        df = df.where(pd.notna(df), None)

        # Si c'est le fichier olist_products_dataset.csv, remplacer les valeurs vides dans les colonnes numériques par 0
        if 'products' in table_name:
            # Colonnes spécifiques pour lesquelles remplacer les valeurs vides par 0
            columns_to_replace = ['product_name_lenght', 'product_description_lenght', 'product_photos_qty', 
                                  'product_weight_g', 'product_length_cm', 'product_height_cm', 'product_width_cm']
            df[columns_to_replace] = df[columns_to_replace].fillna(0)


        # Convertir les colonnes 'has_company' et 'has_gtin' en booléens si elles existent dans le fichier
        if 'has_company' in df.columns:
            df['has_company'] = df['has_company'].apply(lambda x: True if x == 1.0 else False)

        if 'has_gtin' in df.columns:
            df['has_gtin'] = df['has_gtin'].apply(lambda x: True if x == 1.0 else False)


        # Connexion et curseur
        cursor = conn.cursor()

        # Générer la requête INSERT
        columns = list(df.columns)
        placeholders = ', '.join(['%s'] * len(columns))
        query = sql.SQL("INSERT INTO {} ({}) VALUES ({}) ON CONFLICT DO NOTHING").format(
            sql.Identifier(table_name),
            sql.SQL(', ').join(map(sql.Identifier, columns)),
            sql.SQL(placeholders)
        )

        # Insérer chaque ligne dans la base de données
        for row in df.itertuples(index=False, name=None):
            cursor.execute(query, row)

        # Valider la transaction
        conn.commit()
        cursor.close()
        print(f"✅ Données insérées dans {table_name} ({len(df)} lignes)")

    except Exception as e:
        print(f"Erreur lors de l'insertion dans {table_name} :", e)
        conn.rollback()

# Exécuter l'importation pour toutes les tables
def main():
    conn = connect_db()
    if conn:
        for table, csv_file in TABLES_CSV_MAPPING.items():
            insert_csv_to_db(table, csv_file, conn)
        conn.close()
        print("Toutes les insertions sont terminées !")

# Lancer l'importation
if __name__ == "__main__":
    main()
