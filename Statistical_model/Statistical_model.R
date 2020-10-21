library(readxl)
library(rms)
library(ggplot2)
data <- data.frame(read_xlsx(""))

#Data processing Part I
data$reviewtime <- round(difftime(data$lastime, data$firstime, units = c("hours")),0)
data$Purpose <- ifelse(grepl("doc|copyright|license", data$Description, ignore.case = T), "Document", 
                            ifelse(grepl("bug|fix|defect", data$Description, ignore.case = T), "Bug", "Feature"))
model_data <- data.frame(data$reviewtime, data$Reviewer, data$Reviewer_Comment, data$Author_Comment,
                         data$Total_Comment, data$insertions, data$deletions, data$churn,
                         data$Revision, data$File, data$Author_Exp, data$internal, data$external, data$total_link,
                         data$Purpose)
names(model_data)[1] <- "Reviewtime"
names(model_data)[2] <- "Commenter"
names(model_data)[3] <- "Reviewer_Comment"
names(model_data)[4] <- "Author_Comment"
names(model_data)[5] <- "Total_Comment"
names(model_data)[6] <- "insertions"
names(model_data)[7] <- "deletions"
names(model_data)[8] <- "churn"
names(model_data)[9] <- "revision"
names(model_data)[10] <- "file"
names(model_data)[11] <- "Author_Exp"
names(model_data)[12] <- "internal"
names(model_data)[13] <- "external"
names(model_data)[14] <- "total_link"
names(model_data)[15] <- "purpose"
model_data$Reviewtime <- as.numeric(model_data$Reviewtime)
dd <- datadist(model_data)
options(datadist = "dd")
model_data
#Model Construction Part II
#Step1 calculate the budget
budget = floor ( model_data$Reviewtime / 15)
budget
#Step2 Normality adjustment
library(moments)
skewness ( model_data$Reviewtime )
kurtosis ( model_data$Reviewtime )

#Step3 Correlation analysis
library(rms)
ind_vars = c('Commenter', 'Reviewer_Comment', 'Author_Comment','Total_Comment','insertions','deletions',
             'churn','revision','file','Author_Exp','internal','external','total_link','purpose')
vc <- varclus(~ ., data=model_data[,ind_vars], trans="abs")
plot(vc)
threshold <- 0.7
abline(h=1-threshold, col = "red", lty = 2)

reject_vars <- c('churn','total_link','Total_Comment', 'Commenter')
ind_vars <- ind_vars[!(ind_vars %in% reject_vars)]
vc <- varclus(~ ., data=model_data[,ind_vars], trans="abs")
plot(vc)
threshold <- 0.7
abline(h=1-threshold, col = "red", lty = 2)

reject_vars <- c('Reviewer_Comment')
ind_vars <- ind_vars[!(ind_vars %in% reject_vars)]

#Step4 Redundancy analysis
red <- redun(~., data=model_data[,ind_vars], nk=0) 
red
#Step5 Allocate degrees of freedom using log1p
spearman2 = spearman2(log1p(Reviewtime) ~ revision + Reviewer_Comment + Author_Comment+insertions+file+ internal+Author_Exp+deletions+external+purpose, data = model_data, p=2)
plot(spearman2)
#Step6 Model Construction
fit <- ols(log1p(Reviewtime) ~ rcs(revision,5) + rcs(Reviewer_Comment,5) + rcs(Author_Comment,5) + rcs(insertions,3) + file + internal +
             Author_Exp + deletions + external + purpose, data=model_data, x=T, y=T)
fit

#Model Evaluation Part III
#Assessment of model stability and calculate AUC
require (rms)
num_iter = 1000
val <- validate (fit, B= num_iter )
val
# Estimate power of explanatory variables
chisq <- anova(fit, test ="Chisq")
chisq
#Examine variables in relation to outcome
bootcov_obj = bootcov(fit, B= num_iter)
bootcov_obj
response_curve = Predict(bootcov_obj,
                             internal,
                             fun = function (x) return (exp(x)))
response_curve
plot(response_curve, ylab="Review time (hours)", xlab="Internal link count",sub ="")

