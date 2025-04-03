# Olist SQL Project
## Description
Ce projet est un ensemble de scripts SQL et de fichiers Python utilisés pour la gestion et l'analyse des données d'un dataset d'une entreprise fictive appelée Olist. Le projet se compose de plusieurs étapes, y compris la création de la base de données, le remplissage des tables avec des données, et l'exécution de requêtes SQL pour répondre à des questions spécifiques.

Le dataset contient des informations sur les clients, les commandes, les produits, les paiements, les évaluations des commandes, et les vendeurs.

## Structure du projet
La structure des fichiers dans ce projet est la suivante :

```bash
Copier le code
/Olist_SQL_Project
|-- script.sql               # Script pour créer les tables et les contraintes
|-- script.py                # Script Python pour remplir les tables
|-- requetes.sql             # Requêtes SQL pour répondre aux questions spécifiques
|-- olist_dataset/           # Dossier contenant les fichiers CSV des différentes tables
    |-- olist_customers.csv  # Données des clients
    |-- olist_geolocation.csv # Données de géolocalisation des clients
    |-- olist_order_items.csv # Détails des articles dans les commandes
    |-- olist_order_payments.csv # Détails des paiements des commandes
    |-- olist_order_reviews.csv  # Avis des commandes
    |-- olist_orders.csv     # Détails des commandes
    |-- olist_products.csv   # Détails des produits
    |-- olist_sellers.csv    # Informations sur les vendeurs
    |-- product_category_name_translation.csv # Traduction des catégories de produits
```

    
## Contenu des fichiers
### 1. script.sql
Ce fichier contient les instructions SQL nécessaires pour créer les tables et les contraintes dans la base de données. Voici les principales tables créées dans ce script :

#### olist_customers : Informations sur les clients.

#### olist_geolocation : Données de géolocalisation des clients.

#### olist_order_items : Détails des articles présents dans les commandes.

#### olist_order_payments : Détails des paiements pour chaque commande.

#### olist_order_reviews : Avis et évaluations laissés par les clients sur leurs commandes.

#### olist_orders : Informations détaillées sur les commandes.

#### olist_products : Détails des produits disponibles à la vente.

#### olist_sellers : Informations sur les vendeurs.

#### product_category_name_translation : Traduction des catégories de produits.

### 2. script.py
Le fichier Python script.py contient un code permettant de remplir les tables de la base de données en important les données des fichiers CSV du dossier olist_dataset/. Ce script assure le prétraitement et l'insertion des données dans les tables respectives.

### 3. requetes.sql
Ce fichier contient les requêtes SQL qui répondent à diverses questions analytiques. Chaque requête est utilisée pour extraire des informations précieuses du dataset, telles que le chiffre d'affaires par catégorie de produit, les tendances de ventes par ville, les délais de livraison, et plus encore. Les requêtes sont organisées par thème et visent à fournir des insights sur les performances commerciales.

### 4. olist_dataset/
Ce dossier contient les fichiers CSV des différentes tables. Chaque fichier correspond à une table de la base de données et contient les données nécessaires pour remplir ces tables.

#### olist_customers.csv : Liste des clients avec des informations comme l'ID client, la ville, et l'état.

#### olist_geolocation.csv : Données géographiques associées aux clients (code postal, latitude, longitude).

#### olist_order_items.csv : Informations détaillées sur les articles des commandes.

#### olist_order_payments.csv : Détails des paiements effectués pour les commandes.

#### olist_order_reviews.csv : Avis et commentaires des clients sur leurs commandes.

#### olist_orders.csv : Détails des commandes passées.

#### olist_products.csv : Détails des produits disponibles dans la boutique en ligne.

#### olist_sellers.csv : Détails des vendeurs.

#### product_category_name_translation.csv : Traductions des catégories de produits.

## Installation
### Cloner le dépôt :

Pour cloner le dépôt, utilisez la commande suivante :

```bash
Copier le code
git clone <URL_DU_REPO>
```
### Créer la base de données :

Exécutez le script SQL script.sql sur votre serveur de base de données pour créer les tables nécessaires.

sql
Copier le code
\i script.sql
Remplir la base de données :

Exécutez le script Python script.py pour charger les données des fichiers CSV dans les tables correspondantes. Assurez-vous que le fichier CSV se trouve dans le dossier olist_dataset/.

```bash
Copier le code
python script.py
Exécuter les requêtes :

Après avoir chargé les données, vous pouvez exécuter les requêtes SQL dans requetes.sql pour obtenir les résultats analytiques.
```
## Utilisation
Le projet fournit des outils pour analyser les ventes, la performance des produits, des vendeurs, ainsi que des informations sur les délais de livraison et la satisfaction des clients.

Voici quelques exemples d'analyses que vous pouvez effectuer :

### Chiffre d'affaires par catégorie de produit et par ville

### Répartition des ventes par vendeur et par région

### Analyse des délais de livraison

### Taux de conversion des leads

### Analyse des avis des clients et du score moyen

## Auteurs
HAMI Anyes
