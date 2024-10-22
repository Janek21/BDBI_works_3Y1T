
##SERGI OCAÑA ALAMO


library("dbscan");  #Library of clustering
library("MASS"); #Library for dummy datasets
library(mclust); #LLibrary for another type to make clusters

library(ggplot2) #Library to make plots and see them

# Comment all the lines with informative comments.

# Task 1) Implement a dummy dataset with two dimensions that looks like Smiley.



set.seed(42)  #Set for random data

#  function to add multivariate Gaussian noise to a set of points
add_mv_noise <- function(x, y, cov_matrix) { #Variables for the function
  n <- length(x)   # Number of points
  noise <- mvrnorm(n, mu = c(0, 0), Sigma = cov_matrix)  # Generate multivariate noise
  x_noisy <- x + noise[,1]  # Add noise to x-coordinates
  y_noisy <- y + noise[,2]  # Add noise to y-coordinates
  return(list(x = x_noisy, y = y_noisy))  # Return a list with noisy x and y
}

# Covariance matrices of noise, correlation noise between x and y
cov_matrix_circle <- matrix(c(0.1, 0, 0, 0.1), ncol = 2)  # First parameter  Low noise for face
cov_matrix_eyes <- matrix(c(0.3, 0, 0, 0.2), ncol = 2)    # More noise for eyes
cov_matrix_mouth <- matrix(c(0.7, 0, 0, 0.1), ncol = 2)   # High noise for the mouth to make the moth like it was open

# Generate random angles and radii for the face circle
theta <- runif(400, 0, 2*pi)  # Random angles to make the circle of the face
radius <- 8 + rnorm(400, sd = 0.3)  #Here we put a value for the radius (how big the face) and the noise also 
x_circle <- radius * cos(theta)  # x-coordinates of the face
y_circle <- radius * sin(theta)  # y-coordinates of the face

#multivariate noise to the face circle
noisy_circle <- add_mv_noise(x_circle, y_circle, cov_matrix_circle)

# left eye 
x_eye1 <- rnorm(100, mean = -3, sd = 0.3)  # x-coordinates of left eye 
y_eye1 <- rnorm(100, mean = 3, sd = 0.3)   # y-coordinates of left eye, x and y to situate the eyes in the face

# Apply multivariate noise to the left eye
noisy_eye1 <- add_mv_noise(x_eye1, y_eye1, cov_matrix_eyes) #Make the eye a litle bit disperse

#right eye 
x_eye2 <- rnorm(100, mean = 3, sd = 0.3)   # x-coordinates of right eye
y_eye2 <- rnorm(100, mean = 3, sd = 0.3)   # y-coordinates of right eye, the same as the left eye

#multivariate noise to the right eye
noisy_eye2 <- add_mv_noise(x_eye2, y_eye2, cov_matrix_eyes)

# Generate the full circle for the open mouth
theta_mouth <- seq(pi, 2*pi, length.out = 200) #Generate angles for a full circle
radius_mouth <- 1 + rnorm(200, sd = 0.2)  #radius litle to make it a smaller circle for the mouth
x_mouth <- radius_mouth * cos(theta_mouth)  # x-coordinates for the mouth
y_mouth <- radius_mouth * sin(theta_mouth) - 2  #y coordinates and the -2 to put it in the bottom part of the face

# Apply multivariate noise to the mouth and get the full circle
noisy_mouth <- add_mv_noise(x_mouth, y_mouth, cov_matrix_mouth)

# Combine all parts like Frankenstein to get the face
x <- c(noisy_circle$x, noisy_eye1$x, noisy_eye2$x, noisy_mouth$x)  # Combine x-coordinates, half face
y <- c(noisy_circle$y, noisy_eye1$y, noisy_eye2$y, noisy_mouth$y)  # Combine y-coordinates, half face
smiley_face <- data.frame(x, y)  # Create the full face with all the data

# Plot the noisy smiley face, with labels and titles, face with dots
plot(smiley_face$x, smiley_face$y, asp = 1, pch = 16, cex = 0.6, xlab = "X", ylab = "Y", main = "Noisy Smiley Face with mvrnorm")



# Task 2) Apply to the Smiley face the kmeans algorithm and K = 3. Paint the result

k <- 3  # Number of clusters
kmeans_result <- kmeans(smiley_face, centers = k)  # Perform k-means clustering

# Add the cluster labels to the dataset
smiley_face$cluster <- as.factor(kmeans_result$cluster)  # Convert to factor for coloring

# Plot the k-means clustering result
plot(smiley_face$x, smiley_face$y, asp = 1, pch = 16, cex = 0.6, 
     col = smiley_face$cluster, xlab = "X", ylab = "Y", main = "K-means Clustering of Smiley Face") #Labels and titles
legend("topright", legend = paste("Cluster", 1:k), col = 1:k, pch = 16)  #Adding the legend to the plot



# Do we get meaningfull clusters? Why?

#Not very usefull as each point can belong to any cluster as the center is in the middle of the face

# Task 3) Apply the kmeans with an increasing number of clusters (say, from 2 to 20).
# For each of the proposed k, compute the mean distance within each cluster.
# Plot the result of K vs the average distance within


# make sure that x and y are numeric
smiley_face$x <- as.numeric(as.character(smiley_face$x))
smiley_face$y <- as.numeric(as.character(smiley_face$y))

# Convert the cluster column to numeric 
smiley_face$cluster <- as.numeric(as.character(smiley_face$cluster))

dist_vector = c() #create the vector for the mean distances
for (i in 2:20){ #the for loop from the number of clusters
  list <- kmeans(smiley_face, i) #Apply the k means for clustering for each
  coords <- list$withinss #Store the distances inside each clusters
  dist <- mean(coords) # Make the mean
  dist_vector <- c(dist_vector, dist) #Put it in the vector we create for it
}

plot(2:20, dist_vector, #Plot the mean distance against the number of clusters 
     type = "b",              #Line and plots  
     col = "blue",      #Color of them 
     xlab = "K", 
     ylab = "Mean Distance",
     main = "Mean Distance Between Cluster Centroids") #Labels and titles


average_distances <- numeric(19)  # For k = 2 to 20 

# Loop through different values of k (2 to 20)
for (k in 2:20) {
  kmeans_result <- kmeans(smiley_face[, c("x", "y")], centers = k)  # Perform k-means clustering
  
  # Calculate distances from each point to its cluster center
  distances <- numeric(nrow(smiley_face))  # Vector to store the distances
  
  for (i in 1:k) { #For loop for all the clusters 
    cluster_points <- smiley_face[kmeans_result$cluster == i, c("x", "y")]  # Points in  each cluster i
    cluster_center <- kmeans_result$centers[i, ]  # Center of each cluster i
    
    # Calculate distances only if there are points in the cluster (>0)
    if (nrow(cluster_points) > 0) {
      distances[kmeans_result$cluster == i] <- sqrt(rowSums((cluster_points - cluster_center) ^ 2))  # Calculate distances by squaring the difference between each point of the cluster and the center
    }
  }
  
  # Compute the average distance within the cluster, ignoring values NAs
  average_distances[k - 1] <- mean(distances, na.rm = TRUE)  # Store the mean distance
}

# Data for plotting for eack cluster
distance_data <- data.frame(k = 2:20, average_distance = average_distances)

# Remove any rows with NA values if there are any
distance_data <- na.omit(distance_data)

# Plot K vs Average Distance
ggplot(distance_data, aes(x = k, y = average_distance)) +
  geom_line() +  # Line for the average distance
  geom_point(size = 2, color = "blue") +  # Points for each k value
  labs(title = "K vs Average Distance Within Clusters",
       x = "Number of Clusters (K)",
       y = "Average Distance Within Clusters") + #Labels and titles
  theme_minimal()  # Use a minimal theme

# What is happening with the distance within each cluster? Why? What would be the minimum
# distance?

#From k=2 to k = 8 it decreases, after that it starts to go up and down so what may
#happen is that well separated clusters are subdivided into smaller ones leading to error

#The optimal number of clusters is k = 8, as it results
#in the smallest average distance within clusters.


# Task 4) Repeat the clustering with dbscan. Use minPts = 5. Do we need to specify the number of clusters? Why?

# How many clusters do you identify? What is happening?


eps <- 1.0 #Is the parameter that sets the maximum distance to consider neighbour a point from the other
minPts <- 5 #Minimum number of dots to consider them a cluster

dbscan_result <- dbscan(smiley_face[, 1:2], eps = eps, minPts = minPts) #aplly the dbscan cluster algorithm for columns from the dataset (x and y) and using eps and min pts.

# Add the cluster assignments to smiley data
smiley_face$dbscan_cluster <- as.factor(dbscan_result$cluster)

# How many clusters there are
num_clusters <- length(unique(dbscan_result$cluster)) 

ggplot(smiley_face, aes(x = x, y = y, color = dbscan_cluster)) + #Coordinates are plotted and coloured by the cluster they belong to 
  geom_point() +
  labs(title = "DBSCAN Clustering of Smiley Face", x = "X", y = "Y") +
  scale_color_discrete(name = "Cluster") +
  theme_minimal()

num_clusters #Print the number of clusters


# Task 5) Create a dummy dataset of two features and 150 observations. Each 50 observations come from a different
# multivariate normal distribution with its own mean vector and variance covariance matrix


# Set seed for random numbers
set.seed(38)

# Define parameters for the three distributions
mean1 <- c(1, 2)         # Mean vector for the first distribution
cov1 <- matrix(c(1, 0.5, 0.5, 1), nrow = 2)  # Covariance matrix for the first distribution

mean2 <- c(5, 4)         # Mean vector for the second distribution
cov2 <- matrix(c(1, -0.5, -0.5, 1), nrow = 2) # Covariance matrix for the second distribution

mean3 <- c(9, 1)         # Mean vector for the third distribution
cov3 <- matrix(c(2, 0.3, 0.3, 2), nrow = 2)  # Covariance matrix for the third distribution


n <- 50  # Number of observations per distribution

# Generate samples with library MASS for the 3 distributions
samples1 <- mvrnorm(n, mu = mean1, Sigma = cov1)
samples2 <- mvrnorm(n, mu = mean2, Sigma = cov2)
samples3 <- mvrnorm(n, mu = mean3, Sigma = cov3)

# Combine samples into a single dataset
dataset <- rbind(samples1, samples2, samples3)

# Convert to a data frame and add a label column
df <- data.frame(x = dataset[, 1], y = dataset[, 2],
                 group = rep(1:3, each = n))

# Task 6) Apply mclust, which applies a mixture of Gaussian distributions. Check the Mclust command. 
# What is G? How can you use it?

#G is to determine the number of clusters

mclust_model <- Mclust(df[, c("x", "y")])  # Fitting the model on x and y columns

summary(mclust_model) #Just to see some relevant data of the model

# Plot the clustering results
plot(mclust_model, what = "classification")

# Get the number of clusters (G) used in the model
num_clusters <- mclust_model$G
print(paste("Number of clusters (G):", num_clusters))

# What would happen if you try with the smiley.face? Why is this happening???

smiley_mclust_model <- Mclust(smiley_face[, c("x", "y")]) #We apply the mcluster algortihm to the smiley data

summary(smiley_mclust_model) #See some information of the model


plot(smiley_mclust_model, what = "classification") #Plot it to compare results from above 


print(paste("Number of clusters (G):", smiley_mclust_model$G)) #We get G (number of clusters)

#We get 9 clusters with the mclust instead of the 4 we got before with dbscan
