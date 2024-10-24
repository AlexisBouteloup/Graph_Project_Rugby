library(tidyverse)
library(igraph)
library(RColorBrewer)
library(ggplot2)
library(GGally)
library(cluster)
library(readxl)

rugby = read_excel("C:/Users/Boute/Desktop/Graph/Graph_data.xlsx", 
                    sheet = "Nodes")
summary(rugby)

infos_joueurs = read_excel("C:/Users/Boute/Desktop/Graph/Graph_data.xlsx", 
                           sheet = "Infos")
row.names(infos_joueurs) = infos_joueurs$Nom


##toutes les connexions ayant eu lieu dans l'équipe 1
rugby_equipe1 = subset(rugby, Equipe == 1)
##toutes les connexions ayant eu lieu dans l'équipe 2
rugby_equipe2 = subset(rugby, Equipe == 2)
##toutes les connexions ayant eu lieu entre sept-janv
rugby_period1 = subset(rugby, Periode == 1)
##toutes les connexions ayant eu lieu après janv
rugby_period2 = subset(rugby, Periode == 2)


##################################################### quelques infos
sum(infos_joueurs$`Match en 1` != 0)


################################################################################

rugby_all = rugby

# Combiner les deux colonnes pour former des paires
pairs <- paste(pmin(rugby$Nom1, rugby$Nom2), 
               pmax(rugby$Nom1, rugby$Nom2))
# Supprimer les doublons
unique_pairs <- unique(pairs)
# Convertir les paires uniques en dataframe avec deux colonnes
rugby_all <- data.frame(
  col1 = sapply(strsplit(unique_pairs, " "), `[`, 1),
  col2 = sapply(strsplit(unique_pairs, " "), `[`, 2)
)

rugby_all_net = graph_from_data_frame(rugby_all[,c(1,2)],directed=F)

set.seed(5)
plot(rugby_all_net,
     layout =layout.kamada.kawai,
     vertex.size=1.5,
     vertex.color="blue",
     vertex.frame.color="blue",
     vertex.label.cex=0.8,
     vertex.label.color="black",
     vertex.label.dist=0.5)


################################################################################
################################### enlève les pairs

# Combiner les deux colonnes pour former des paires
pairs <- paste(pmin(rugby_equipe1$Nom1, rugby_equipe1$Nom2), 
               pmax(rugby_equipe1$Nom1, rugby_equipe1$Nom2))
# Supprimer les doublons
unique_pairs <- unique(pairs)
# Convertir les paires uniques en dataframe avec deux colonnes
rugby_equipe1 <- data.frame(
  col1 = sapply(strsplit(unique_pairs, " "), `[`, 1),
  col2 = sapply(strsplit(unique_pairs, " "), `[`, 2)
)

# Combiner les deux colonnes pour former des paires
pairs <- paste(pmin(rugby_equipe2$Nom1, rugby_equipe2$Nom2), 
               pmax(rugby_equipe2$Nom1, rugby_equipe2$Nom2))
# Supprimer les doublons
unique_pairs <- unique(pairs)
# Convertir les paires uniques en dataframe avec deux colonnes
rugby_equipe2 <- data.frame(
  col1 = sapply(strsplit(unique_pairs, " "), `[`, 1),
  col2 = sapply(strsplit(unique_pairs, " "), `[`, 2)
)

# Combiner les deux colonnes pour former des paires
pairs <- paste(pmin(rugby_period1$Nom1, rugby_period1$Nom2), 
               pmax(rugby_period1$Nom1, rugby_period1$Nom2))
# Supprimer les doublons
unique_pairs <- unique(pairs)
# Convertir les paires uniques en dataframe avec deux colonnes
rugby_period1 <- data.frame(
  col1 = sapply(strsplit(unique_pairs, " "), `[`, 1),
  col2 = sapply(strsplit(unique_pairs, " "), `[`, 2)
)

# Combiner les deux colonnes pour former des paires
pairs <- paste(pmin(rugby_period2$Nom1, rugby_period2$Nom2), 
               pmax(rugby_period2$Nom1, rugby_period2$Nom2))
# Supprimer les doublons
unique_pairs <- unique(pairs)
# Convertir les paires uniques en dataframe avec deux colonnes
rugby_period2 <- data.frame(
  col1 = sapply(strsplit(unique_pairs, " "), `[`, 1),
  col2 = sapply(strsplit(unique_pairs, " "), `[`, 2)
)


################################################################################
###################################### premiers 5 graphs

rugby_net_equipe1 = graph_from_data_frame(rugby_equipe1[,c(1,2)],directed=F)
rugby_net_equipe2 = graph_from_data_frame(rugby_equipe2[,c(1,2)],directed=F)
rugby_net_periode1 = graph_from_data_frame(rugby_period1[,c(1,2)],directed=F)
rugby_net_periode2 = graph_from_data_frame(rugby_period2[,c(1,2)],directed=F)

set.seed(1)
plot(rugby_net_periode2,
     layout =layout.kamada.kawai,
     vertex.size=2,
     vertex.color = [V(rugby_period2)$gender]
     # vertex.color="#FFEC33",
     vertex.frame.color="#17202A",
     vertex.label.cex=1.2,
     vertex.label.color="#17202A",
     edge.color="#CCD1D1",
     vertex.label.dist=-0.6,
     edge.width=2.8)

################################################################################
##################################### mesures du réseau

# ecount(rugby_all_net)/(vcount(rugby_all_net)*(vcount(rugby_all_net)-1)) # density
edge_density(rugby_net_periode2) # density
transitivity(rugby_net_periode2) # transitivity
mean(degree(rugby_net_periode2)) # mean degree

diameter(rugby_net_periode2) # diamètre
mean(distances(rugby_net_periode2)) #shortest path moyen

################################################################################
################################################################################
#                       Similarity-based algorithms                            #


rugby_sp <- as.dist(distances(rugby_net_periode2, algorithm = "unweighted"))
# as.matrix(rugby_sp)[1:60,1:8]
rugby_hc <- hclust(rugby_sp, method = "ward.D2")
plot(rugby_hc, xlab="", cex=0.9)

############################################# méthode 1 pour trouver la coupe
# Calcul des différences entre les hauteurs
height_diff <- diff(rugby_hc$height)
# Trouver la hauteur de coupe
cutoff_height <- rugby_hc$height[which.max(height_diff)]
# Afficher la hauteur de coupe
print(cutoff_height)

############################################# méthode 2 pour trouver la coupe
plot(rugby_hc$height,xlab="",cex=0.6)


plot(rugby_hc, xlab="", cex=0.9)
abline(h = 13.4, col = "red", lty = 2) # => 3 clusters, coupe 1
abline(h = 4.7, col = "blue", lty = 2) # => 7 cluster, coupe visuelle
abline(h = 3.9, col = "green", lty = 2) # => 9 cluster, coupe logique


rugby_spclustering <- cutree(rugby_hc, k=7) # si on choisit 6 cluster
# permet d'évaluer à quel point la structure communautaire détectée est significative ou non dans le réseau.
modularity(rugby_net_periode2, rugby_spclustering)


#                           Spectral clustering                                #

rugby_L <- laplacian_matrix(rugby_net_periode2, normalized = T, sparse = F)
ggplot(as_tibble(eigen(rugby_L)$values)) +
  geom_point(aes(x=1:length(value),y=sort(value))) +
  labs(x="", y="Eigenvalue", title = "Eigenvalues of L_N")
# il y a des sauts à 4 et 9

K=9
vect_clust<-eigen(rugby_L)$vectors
vect_clust<-vect_clust[,ncol(vect_clust)-0:(K-1)]
rugby_spectral<-kmeans(vect_clust,centers=K)$cluster

modularity(rugby_net_periode2, rugby_spectral) 
# a quel point les noeuds d'une commu sont connectés ( mieux à 9 que 4)


#                           Louvain/Leiden                                     #

# Exécutez l'algorithme Louvain pour obtenir les clusters
rugby_louvain <- cluster_louvain(rugby_net_periode2, weights = NULL)
modularity(rugby_net_periode2, membership(rugby_louvain))

# Exécutez l'algorithme Leiden pour obtenir les clusters
rugby_leiden<-cluster_leiden(rugby_net_periode2,objective_function="modularity")
rugby_leiden$quality



################################################################################
################################################################################
#                         Visualizing communities                              #


plot(rugby_net_periode2,
     vertex.size=3,
     vertex.label.cex=0.8,
     vertex.color=rugby_louvain$membership,
     vertex.label.color=rugby_louvain$membership,
     main=paste("Louvain approach\n(Modularity =", 
                round(modularity(rugby_net_periode2, rugby_louvain$membership),
                      digits=2), "| Clusters =",
                length(unique(rugby_louvain$membership)), ")"),
     edge.color = rgb(0,0,0,.25))

plot(rugby_net_periode2,
     vertex.size=3,
     vertex.label.cex=0.8,
     vertex.color=rugby_spectral,
     vertex.label.color=rugby_spectral,
     main=paste("Spectral approach\n(Modularity =", 
                round(modularity(rugby_net_periode2, rugby_spectral),
                      digits=2), "| Clusters =",
                length(unique(rugby_spectral)), ")"),
     edge.color = rgb(0,0,0,.25))






