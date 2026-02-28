# 🚴 Cyclistic Bike-Share Analysis (SQL Project)

## 📌 Overview

This project explores behavioural differences between **annual members** and **casual riders** using the Cyclistic bike-share dataset.

The goal wasn’t just to analyse rides.

It was to answer one strategic question:

> How can casual riders be converted into annual members using data-backed insights?

All analysis was performed entirely in **MySQL**, focusing on behavioural segmentation, time intelligence, and geospatial insights.

---

## 🛠 Tools Used

* MySQL 8
* Window Functions
* CTEs
* Geospatial Distance (Haversine Formula)
* Bulk Data Loading & Cleaning

---

## 🧹 Data Preparation

Before analysis, several real-world data issues were handled:

* Non-standard date formats converted using `STR_TO_DATE()`
* Empty coordinate values handled safely using `NULLIF()`
* Latitude & longitude optimized using `DECIMAL(9,6)`
* ~8% missing station data carefully imputed using coordinate matching
* Date & time separated for flexible time-based analysis

This ensured clean, analysis-ready data without dropping significant records.

---

## 🔎 What This Analysis Explores

Instead of just counting rides, this project investigates:

* How ride duration differs between user segments
* Whether members exhibit commuter-like behaviour
* If casual riders show leisure-heavy patterns
* Which stations act as conversion hotspots
* How weekend and hourly trends shape demand
* Whether electric bikes influence usage patterns
* Where operational imbalances exist across stations
* How ride distance differs by customer type

The focus is on patterns that drive **strategy**, not just metrics.

---

## 📊 Key Insights

* Casual riders tend to take longer, leisure-oriented rides.
* Members show strong weekday peak-hour patterns — suggesting commute behaviour.
* Weekend usage spikes significantly for casual riders.
* Certain stations are dominated by casual usage, presenting high-potential marketing zones.
* Ride loops (same start & end station) are more common among leisure riders.
* Operational station imbalance suggests opportunities for improved bike redistribution.

---

## 🎯 Strategic Takeaways

* Target high-casual stations with membership campaigns.
* Promote annual plans during weekend spikes.
* Use time-of-day insights to personalise marketing.
* Align operational rebalancing with demand patterns.

---

## 🧠 What This Project Demonstrates

* Advanced SQL querying
* Window function implementation (median calculation)
* Geospatial analytics in MySQL
* Business-focused analytical thinking
* Real-world data cleaning and transformation

---

## 🚀 Final Note

This project goes beyond descriptive analytics.

It demonstrates how SQL can transform raw ride data into:

* Behavioural intelligence
* Operational insights
* Marketing strategy

The real story lives inside the queries.

Let’s make this upload hit different 🚀
