# Load necessary libraries
library(dplyr)
library(ggplot2)
library(readr)

# ## Welcome

# Request data set access through:
# https://pslcdatashop.web.cmu.edu/Project?id=879
# Then go to this link to download the relevant files:
# https://pslcdatashop.web.cmu.edu/Files?datasetId=5833

# ## Reading in Data

# ### Event data (fine-grain position logs of teachers)

# Explanation: Every second, a position of a teacher is logged. Actions are classified in the "content" category
# where actions with target subjects have entries in the "subject" column
df_event <- read_csv('event_master_file_D10_R500_RNG1000_sprint2_shou (1).csv')

# Example aggregation: How many seconds of stop proximity did each student receive?
df_event_filtered <- df_event %>%
  filter(grepl("Stopping", content, ignore.case = TRUE)) %>%
  filter(!grepl("no student seated", subject, ignore.case = TRUE))

stop_proximity_counts <- df_event_filtered %>%
  count(subject)

print(stop_proximity_counts)

# ### Observation Events

# Time-stamped observation note events of humans present in the classroom. Includes visits to students and 
# other relevant teacher behaviors. Often, the subject can be specific seats.
df_observation <- read_tsv('observation_events_anonymized (1).tsv')

# Load the student seat positions
df_seats <- read_csv('student_position_sprint1_shou (1).csv')

# Example aggregation: What were the most common activities in different periods?
activity_counts <- df_observation %>%
  group_by(periodID, event) %>%
  summarise(count = n())

# Plotting the activities
activity_counts %>%
  ggplot(aes(x = factor(periodID))) +
  geom_bar(aes(y = count, fill = event), stat = "identity") +
  theme_minimal() +
  labs(title = "Most Common Activities in Different Periods",
       x = "Period ID",
       y = "Count",
       fill = "Event") +
  theme(legend.position = "right")

# ### Meta Data

# Several outcomes of interest on the student level. Typical outcomes are "ck_lg": conceptual learning gain
# and "pk_lg": procedural learning gain
df_meta <- read_csv('meta-data-aied (1).csv')

# Load the crosswalk for merging with teacher position file
df_crosswalk <- read_csv('crosswalk.csv')

# ## Log Data from Tutoring System

df_tutor_log <- read_tsv('tutor_log_anonymized (1).tsv')

# Display first few rows of the tutoring log
head(df_tutor_log)

# Documentation: https://pslcdatashop.web.cmu.edu/help?page=importFormatTd
# Best to work with me if you are interested in analyzing this data set.
