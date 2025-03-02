# 📚 Data Directory  

This folder contains **exchange rate data** retrieved from various banks. The data is stored in different formats for analysis and historical tracking.

There are rates from [https://www.infodolar.com.do/](https://www.infodolar.com.do/) as well.

---

## 📌 **Folder Structure**  
```
data/
│── from_banks/
│   ├── rds/                 # Daily exchange rate data (RDS format)
│   ├── csv/                 # Daily exchange rate data (CSV format)
│   ├── _historico_from_banks.rds  # Combined historical exchange rate data (RDS)
│   ├── _historico_from_banks.csv  # Combined historical exchange rate data (CSV)
│── infodolar/
│   ├── rds/                 # Daily exchange rate data (RDS format)
│   ├── csv/                 # Daily exchange rate data (CSV format)
│   ├── _historico_infodolar.rds  # Combined historical exchange rate data (RDS)
│   ├── _historico_infodolar.csv  # Combined historical exchange rate data (CSV)
│── processed/
```

---

## 📊 **Data Description**  

| Column       | Description                                    |
|--------------|------------------------------------------------|
| `date`       | Date and time when the data was retrieved      |
| `bank`       | Name of the bank providing the exchange rate   |
| `buy`        | Exchange rate for buying USD                   |
| `sell`.      | Exchange rate for selling USD                  |

The structure might vary depending on bank-specific sources.

---

## 💾 **File Formats & Usage**  

- **RDS (`.rds`)**: Used for faster data reading/writing in R.  
  ```r
  tasas <- readRDS("data/from_banks/rds/2025-03-01.rds")
  ```
- **CSV (`.csv`)**: Used for sharing and compatibility with other tools.  
  ```r
  readr::read_csv("data/from_banks/csv/2025-03-01.csv")
  ```

---

## 🔄 **Data Update Process**  
- The script runs daily to fetch exchange rates.  
- The latest data is stored in the **`rds/` and `csv/`** folders.  
- Historical data is merged into `_historico_from_banks.rds` and `_historico_from_banks.csv`.  

---

## ⚠️ **Important Notes**  
- The data might be incomplete if some banks fail to respond. Check the logs (`log_error` messages).  
- If any file is missing, re-run the extraction script.  

---

