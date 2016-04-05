# 1. Below, I'm opening the 'refine_original' file and turning it into a data frame. 
refine_original <- read.csv("refine_original.csv", header =  TRUE)
df <- data.frame(refine_original)
View(df)
# 2. This is to build an index, or a lookup value based off of the company variable.
df$index <- as.numeric(as.factor(df$company))
# 3. Taking any company with the lookup value of 1-5 and renaming them to "akzo."
df$company[which(df$index <= 5)] <- "akzo"
# 4. Taking any company with the lookup value between 6 and 13 and renaming them to "philips."
df$company[which(df$index <= 13 & df$index >= 6)] <- "philips"
# 5. Taking any company with the lookup value between 14 and 16 and renaming them to "unilever."
df$company[which(df$index <= 16 & df$index >= 14)] <- "unilever"
# 6. Taking any company with the lookup value between 17 and 19 and renaming them to "van houten."
df$company[which(df$index <= 19 & df$index >= 17)] <- "van houten"
# 7. Initiate the tidyr package and use the unite function to bring the address variables into one column.
library(tidyr)
df <- unite(df, "full_address",address, city, country, sep = ",")
# 8. Next, we separate the product code/number into two columns using the separate function from tidyr.
df <- separate(df, Product.code...number, c("product_code","product_number"), sep = "-")
# 9. Below, the code creates a new value for product category based off of the product code.  
df$product_category[df$product_code == "p"] <- "Smartphone"
df$product_category[df$product_code == "v"] <- "TV"
df$product_category[df$product_code == "x"] <- "Laptop"
df$product_category[df$product_code == "q"] <- "Tablet"
# 10. Below, we create a binary matrix based off of the company variable, turn it into a data frame, rename the variables, and then bind them into the original data frame.
company_matrix <- model.matrix( ~ 0. + company, df)
company_names <- data.frame(company_matrix)
library(plyr)
company_names <- rename(company_names, c("companyakzo"="company_akzo", "companyphilips"="company_philips","companyunilever"="company_unilever","companyvan.houten"="company_van_houten"))
df <- cbind(df, company_names)
# 11. And finally, we repeat the process above for the product category variable.
product_matrix <- model.matrix( ~ 0. + product_category, df)
product_names <- data.frame(product_matrix)
product_names <- rename(product_names, c("product_categoryLaptop"="product_laptop","product_categorySmartphone"="product_smartphone","product_categoryTablet"="product_tablet","product_categoryTV"="product_tv"))
df <- cbind(df, product_names)
