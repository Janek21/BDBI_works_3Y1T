#Bruno Álvarez Esteban

install.packages("dbscan")
library("dbscan");
library("MASS");
install.packages("mclust")
library(mclust);

# Comment all the lines with informative comments.

# Task 1) Implement a dummy dataset with two dimensions that looks like Smiley.

set.seed(42)  #Set for random data

#function to add multivariate Gaussian noise to a set of points
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

#CIRCLE FACE

#generate random angles and radi for the face circle
theta <- runif(400, 0, 2*pi)  # Random angles to make the circle of the face
radius <- 8 + rnorm(400, sd = 0.3)  #Here we put a value for the radius (how big the face) and the noise also 
x_circle <- radius * cos(theta)  # x-coordinates of the face
y_circle <- radius * sin(theta)  # y-coordinates of the face

#multivariate noise to the face circle
noisy_circle <- add_mv_noise(x_circle, y_circle, cov_matrix_circle)

#EYES

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

#MOUTH

# Generate the full circle for the open mouth
theta_mouth <- seq(pi, 2*pi, length.out = 200) #Generate angles for a full circle
radius_mouth <- 1 + rnorm(200, sd = 0.2)  #radius litle to make it a smaller circle for the mouth
x_mouth <- radius_mouth * cos(theta_mouth)  # x-coordinates for the mouth
y_mouth <- radius_mouth * sin(theta_mouth) - 3.6 #y coordinates and the -2 to put it in the bottom part of the face

# Apply multivariate noise to the mouth and get the full circle
noisy_mouth <- add_mv_noise(x_mouth, y_mouth, cov_matrix_mouth)

#upper mouth left

x_mouth1 <- rnorm(100, mean = -4, sd = 0.3)  # x-coordinates of left eye 
y_mouth1 <- rnorm(100, mean = -3, sd = 0.3)   # y-coordinates of left eye, x and y to situate the eyes in the face

# Apply multivariate noise to the left eye
#noisy_mouth1 <- add_mv_noise(x_eye1, y_eye1, cov_matrix_eyes) #Make the eye a litle bit disperse
#print(noisy_mouth1)
#noisy_mouth$x <- c(noisy_mouth1$x)
#noisy_mouth$y <- c(noisy_mouth1$y)


# Combine all parts like a zombie, happy halloween
#join for x
x <- c(noisy_circle$x, noisy_eye1$x, noisy_eye2$x, noisy_mouth$x)
#join for y
y <- c(noisy_circle$y, noisy_eye1$y, noisy_eye2$y, noisy_mouth$y)
#make the data fram from the cordiantes
smiley_face <- data.frame(x, y)

#plot to check and see the outcome
plot(smiley_face$x, smiley_face$y, asp = 1, pch = 16, cex = 0.6, xlab = "X", ylab = "Y", main = "Noisy Smiley Face with mvrnorm")


# Task 2) Apply to the Smiley face the kmeans algorithm and K = 3. Paint the result

k <- 3  # Number of clusters
kmeans_result <- kmeans(smiley_face, centers = k)  #the k means algoithm is done with the function "kmeans()" which needs the data frame and the k

#add the cluster labels to the dataset in order to be able to color each cluster depending on its label
smiley_face$cluster <- as.factor(kmeans_result$cluster)  #make it a factor so it is easyer to color

#plot to view the different clusters
plot(smiley_face$x, smiley_face$y, asp = 1, pch = 16, cex = 0.6, 
     col = smiley_face$cluster) #Labels and titles
legend("topleft", legend = paste("Cluster", 1:k), col = 1:k, pch = 16)

# Do we get meaningfull clusters? Why?

#No, because the center is found in the middle (0,0) causing that any point can belonge to any cluster

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
     col = "purple",      #Color of them 
     xlab = "K", 
     ylab = "Mean Distance between clusters",
     main = "Mean Distance Between Cluster Centroids depending on K") #Labels and titles


distances_final <- numeric(19)  #dimension of k = 2 to 20, so there will be 19 values (20-1; since we don't use k=1)

#loop through different values of k (2 to 20)
for (k in 2:20) {
  kmeans_result <- kmeans(smiley_face[, c("x", "y")], centers = k)  #perform k-means clustering
  
  distances <- numeric(nrow(smiley_face))  #vector to store the distances
  
  for (i in 1:k) { #For loop for all the clusters 
    cluster_points <- smiley_face[kmeans_result$cluster == i, c("x", "y")]  # Points in  each cluster i
    cluster_center <- kmeans_result$centers[i, ]  # Center of each cluster i
    
    #compute distances only if there are points in the cluster (more than 0)
    if (nrow(cluster_points) > 0) {
      distances[kmeans_result$cluster == i] <- sqrt(rowSums((cluster_points - cluster_center) ^ 2))  # Calculate distances by squaring the difference between each point of the cluster and the center
    }
  }
  
  # Compute the average distance within the cluster, ignoring values NAs
  distances_final[k - 1] <- mean(distances, na.rm = TRUE)  # Store the mean distance
}
#print(distances)
#transform the vector to a data fram for ploting
data_to_plot <- data.frame(k = 2:20, average_distance = distances_final)

#remove rows with Na
data <- na.omit(data_to_plot)

#plot K vs Average Distance
ggplot(data, aes(x = k, y = average_distance)) +
  geom_line() +  # Line for the average distance
  geom_point(size = 2, color = "purple") +  # Points for each k value
  labs(title = "K vs Average Distance Within Clusters",
       x = "Number of Clusters (K)",
       y = "Average Distance Within Clusters") + #Labels and titles
  theme_minimal()  # Use a minimal theme

# What is happening with the distance within each cluster? Why? What would be the minimum
# distance?

#As K increases the distances become smaller since there are more cluster and therefore each
#cluster contains less points, and only the closest points form a cluster making the distance smaller.
#The minimum distance would be 0, making it that in that cluster there is only 1 point being itself the
#centroid, and with a big eoungh K that will happen to all clusters.

# Task 4) Repeat the clustering with dbscan. Use minPts = 5. Do we need to specify the number of clusters? Why?

#No we do not need to specify the number of clusters, the number of clusters will be determined depending on if the 
#points are grouped close enough to be a particular cluster or they are from different ones and if there are enough close
#enough points to be called a cluster.


eps <- 1.0 #is the parameter that establishes the greatest separation between two points considered neighbors
minPts <- 5 #the bare minimum of dots required to qualify as a cluster

#we cluster using the dbscan algo with the values of eps and minPts we defined previously
dbscan_cluster <- dbscan(smiley_face[, 1:2], eps = eps, minPts = minPts)
# Add the cluster assignments to smiley data
smiley_face$cluster_with_dbscan <- as.factor(dbscan_cluster$cluster)

# How many clusters there are
num_clusters <- length(unique(dbscan_cluster$cluster)) 

ggplot(smiley_face, aes(x = x, y = y, color = cluster_with_dbscan)) +
  geom_point() +
  labs(title = "clusters made by dbscan algo for the smiley", x = "X", y = "Y") +
  scale_color_discrete(name = "Cluster") + #we use the cluster they belong to to determine the colour
  theme_minimal()

print(num_clusters)

# How many clusters do you identify? What is happening?

#we can identify 4 clusters, 1 for each eye, one for the face (the cirlce), and the last one for the mouth.
#As we can expect since this are the 4 different groups and they are not even close to each other to be considered
#a cluster all together.

# Task 5) Create a dummy dataset of two features and 150 observations. Each 50 observations come from a different
# multivariate normal distribution with its own mean vector and variance covariance matrix

set.seed(1)

#determine parameters for the three distributions
mean1 <- c(1, 2) #(x, y)
cov1 <- matrix(c(1, 0.5, 0.5, 1), nrow = 2)  #covariance matrix

mean2 <- c(7, 8)
cov2 <- matrix(c(1, -0.3, -0.2, 1), nrow = 2)

mean3 <- c(3, 5)
cov3 <- matrix(c(2, 0.5, 0.4, 2), nrow = 2)


n <- 50  #observations per distribution is 50 as stated in the task

#we generate the 3 samples making use of the function mvnorm from the library mass wich requires the mu
#that is our mean, the central point. And the sigma, the "noise" or extra points we will add that come determined
#by the covariance matrix
samples1 <- mvrnorm(n, mu = mean1, Sigma = cov1)
samples2 <- mvrnorm(n, mu = mean2, Sigma = cov2)
samples3 <- mvrnorm(n, mu = mean3, Sigma = cov3)

# Combine samples into a single dataset
dataset <- rbind(samples1, samples2, samples3)

##we transform to a data frame and add a new column to asign a label column
df <- data.frame(x = dataset[, 1], y = dataset[, 2],
                 group = rep(1:3, each = n))


# Task 6) Apply mclust, which applies a mixture of Gaussian distributions. Check the Mclust command. 
# What is G? How can you use it?

#The G is used to determine how many number of clusters will be

mclust_model <- Mclust(df[, c("x", "y")])  #fitting the model on x and y columns

summary(mclust_model) #to see any important data and see if there is any weirdeness

#we plot tp see the result of our clusters
plot(mclust_model, what = "classification")

#we retrieve the number of clusters in our model, this is G
num_clusters <- mclust_model$G
print(paste("There is a total amount of clusters (G) of", num_clusters))

# What would happen if you try with the smiley.face? Why is this happening???

smiley_mclust_model <- Mclust(smiley_face[, c("x", "y")]) #applyinf the mcluster algo to smiley data

summary(smiley_mclust_model) #Swatvh for any weirdeness

#plot to see the result and compare results
plot(smiley_mclust_model, what = "classification")


print(paste("There is a total amount of clusters (G) of", smiley_mclust_model$G))

#with the mclust we obtain 9 clusters instead of 4 (which we obtained with the dbscan)


