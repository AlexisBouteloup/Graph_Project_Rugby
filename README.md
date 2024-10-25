# Rugby Team Network Analysis

## Overview

This project focuses on analyzing the structure of a rugby team's player network to determine whether it exhibits homophily (i.e., players with similar characteristics are more likely to form competitive relationships). Using graph theory techniques, we study the relationships and competition patterns between players, collected manually from an actual rugby team. Additionally, we investigate how information propagates within this network.

## Project Goals

- **Analyze Homophily in Player Competition Network**: Explore whether players with similar attributes tend to compete more frequently with each other.
- **Information Propagation Study**: Investigate how information spreads across the network and what roles certain players or subgroups play in this process.
  
## Data Collection

The data for this project was collected manually from a rugby team. Each node in the network represents a player, while the edges represent competitive relationships between them.

## Techniques Used

- **Graph Theory**: For building and analyzing the competition network between players.
- **Homophily Analysis**: To test if the network exhibits tendencies of players competing more frequently with those who are similar to them.
- **Information Propagation**: Studying how information flows through the network to identify influential players or hubs.

## Files in this Repository

- graph_project_rugby.xlsx: Contains the raw data of the rugby team’s player network.
- graph_project_rugby.r: R script used for data analysis and visualization.
- graph_project_rugby.pdf: Discussion, including graphs and visualizations from the study.

## Packages used

- `tidyverse`
- `igraph`
- `RColorBrewer`
- `GGally`
- `cluster`

## Results
- **Homophily Findings**: Summarizes whether competition relationships are more frequent between similar players.
- **Network Influence**: Key insights into which players have the most influence in terms of information propagation.


## Author
Bouteloup Alexis & Arpaliangeas Jade
