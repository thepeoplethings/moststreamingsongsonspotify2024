library(shiny)
library(shinydashboard)

options(scipen = 99) # me-non-aktifkan scientific notation
library(dplyr) # data prep
library(lubridate) # date data prep
library(ggplot2) # visualisasi statis
library(plotly) # plot interaktif
library(glue) # setting tooltip
library(scales) # mengatur skala pada plot

# Mempersiapkan data 

spotify_data <- read.csv("Most Streamed Spotify Songs 2024.csv")

spotify_data$Spotify.Streams <- as.numeric(gsub(",", "", spotify_data$Spotify.Streams))
spotify_data$YouTube.Views <- as.numeric(gsub(",", "", spotify_data$YouTube.Views))
spotify_data$TikTok.Views <- as.numeric(gsub(",", "", spotify_data$TikTok.Views))
spotify_data$TikTok.Likes <- as.numeric(gsub(",", "", spotify_data$TikTok.Likes))
spotify_data$Spotify.Playlist.Reach <- as.numeric(gsub(",", "", spotify_data$Spotify.Playlist.Reach))
spotify_data$TikTok.Posts <- as.numeric(gsub(",","", spotify_data$TikTok.Posts))

# Calculate overview stats
total_streams <- sum(spotify_data$Spotify.Streams, na.rm = TRUE)
top_streamed_song <- spotify_data %>% filter(Spotify.Streams == max(Spotify.Streams, na.rm = TRUE)) %>% select(Track, Spotify.Streams)
top_streamed_artist <- spotify_data %>% group_by(Artist) %>% summarise(Total.Streams = sum(Spotify.Streams, na.rm = TRUE)) %>% arrange(desc(Total.Streams)) %>% top_n(1)
total_youtube_views <- sum(spotify_data$YouTube.Views, na.rm = TRUE)
total_tiktok_views <- sum(spotify_data$TikTok.Views, na.rm = TRUE)
total_tiktok_likes <- sum(spotify_data$TikTok.Likes, na.rm = TRUE)
average_playlist_reach <- mean(spotify_data$Spotify.Playlist.Reach, na.rm = TRUE)
