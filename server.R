# Calculate overview stats
total_streams <- sum(spotify_data$Spotify.Streams, na.rm = TRUE)
total_youtube_views <- sum(spotify_data$YouTube.Views, na.rm = TRUE)

# Filter for Top 10 Most Streamed Songs
top_songs <- spotify_data %>%
  arrange(desc(Spotify.Streams)) %>%
  head(10)

# Filter for Top 10 Most Streamed Artists
top_artists <- spotify_data %>%
  group_by(Artist) %>%
  summarise(Total.Streams = sum(Spotify.Streams, na.rm = TRUE),
            Total.YouTube.Views = sum(YouTube.Views, na.rm = TRUE),
            Total.TikTok.Views = sum(TikTok.Views, na.rm = TRUE)) %>%
  arrange(desc(Total.Streams)) %>%
  head(10)

top_10_artists <- spotify_data %>%
  group_by(Artist) %>%
  summarise(Total.Streams = sum(Spotify.Streams, na.rm = TRUE),
            Total.YouTube.Views = sum(YouTube.Views, na.rm = TRUE),
            Total.TikTok.Views = sum(TikTok.Views, na.rm = TRUE),
            Total.TikTok.Posts = sum(TikTok.Posts, na.rm = TRUE)) %>%
  arrange(desc(Total.TikTok.Posts)) %>%
  head(10)

# If Genre column is missing, identify K-Pop artists using their names
kpop_artists <- c("BTS", "BLACKPINK", "TWICE", "EXO", "RED VELVET", "SEVENTEEN", "STRAY KIDS", "NCT", "GOT7", "MAMAMOO")

# Filter for Top 10 Most Streamed K-Pop Artists
top_kpop_artists <- spotify_data %>%
  filter(Artist %in% kpop_artists) %>%
  group_by(Artist) %>%
  summarise(Total.Streams = sum(Spotify.Streams, na.rm = TRUE),
            Total.YouTube.Views = sum(YouTube.Views, na.rm = TRUE)) %>%
  arrange(desc(Total.Streams)) %>%
  head(10)

# Filter for Top 15 Most Used Viral Songs on TikTok
top_tiktok_songs <- spotify_data %>%
  arrange(desc(TikTok.Posts)) %>%
  head(15)

shinyServer(function(input,output) {
  
  output$top_songs_plot <- renderPlotly({
    plot1 <- ggplot(top_songs, aes(x = reorder(Track, Spotify.Streams), y = Spotify.Streams)) +
      geom_point(size = 3, color = "blue") +
      geom_segment(aes(x = Track, xend = Track, y = 0, yend = Spotify.Streams), color = "blue") +
      coord_flip() +
      theme_minimal() +
      labs(title = "Top 10 Most Streamed Songs on Spotify",
           x = "Track",
           y = "Spotify Streams")
    ggplotly(plot1)
  })
  
  output$top_artists_plot <- renderPlotly({
    plot2 <- ggplot(top_artists, aes(x = reorder(Artist, Total.Streams), y = Total.Streams)) +
      geom_bar(stat = "identity", fill = "skyblue") +
      coord_flip() +
      theme_minimal() +
      labs(title = "Top 10 Most Streamed Artists on Spotify",
           x = "Artist",
           y = "Total Streams")
    ggplotly(plot2)
  })
  selected_artist_data <- reactive({
    req(input$selected_artist)
    spotify_data %>% filter(Artist == input$selected_artist)
  })
  
  output$youtube_tiktok_plot_artist <- renderPlotly({
    artist_data <- selected_artist_data()
    plot3 <- ggplot(artist_data, aes(x = YouTube.Views, y = TikTok.Views)) +
      geom_point(size = 3, color = "blue") +
      geom_smooth(method = "lm", se = FALSE, color = "red") +
      theme_minimal() +
      labs(title = paste("YouTube Views vs TikTok Views for", input$selected_artist),
           x = "YouTube Views",
           y = "TikTok Views")
    ggplotly(plot3)
  })
  
  output$top_kpop_artists_plot <- renderPlotly({
    plot4 <- ggplot(top_kpop_artists, aes(x = reorder(Artist, Total.Streams), y = Total.Streams)) +
      geom_bar(stat = "identity", fill = "pink") +
      coord_flip() +
      theme_minimal() +
      labs(title = "Top 10 Most Streamed K-Pop Artists on Spotify",
           x = "K-Pop Artist",
           y = "Total Streams")
    ggplotly(plot4)
  })
  
 selected_kpop_artist_data <- reactive({
    req(input$selected_kpop_artist)
    spotify_data %>% filter(Artist == input$selected_kpop_artist)
  })
  
  output$youtube_views_plot_kpop_artist <- renderPlotly({
    kpop_artist_data <- selected_kpop_artist_data()
    plot5 <- ggplot(kpop_artist_data, aes(x = reorder(Track, YouTube.Views), y = YouTube.Views)) +
      geom_point(size = 3, color = "purple") +
      geom_segment(aes(x = Track, xend = Track, y = 0, yend = YouTube.Views), color = "purple") +
      coord_flip() +
      theme_minimal() +
      labs(title = paste("Most Viewed Songs on YouTube for", input$selected_kpop_artist),
           x = "Track",
           y = "YouTube Views")
    ggplotly(plot5)
  })
  
  output$top_tiktok_songs_plot <- renderPlotly({
    plot6 <- ggplot(top_10_artists, aes(x = reorder(Artist, Total.TikTok.Posts), y = Total.TikTok.Posts)) +
      geom_bar(stat = "identity", fill = "cyan") +
      coord_flip() +
      theme_minimal() +
      labs(title = "Top 10 Artists with Most TikTok Posts",
           x = "Artist",
           y = "TikTok Posts")
    ggplotly(plot6)
  })
  
  output$spotify_popularity_plot <- renderPlotly({
    top_15_songs <- spotify_data %>%
      arrange(desc(Spotify.Popularity)) %>%
      head(15)
    
    plot7 <- ggplot(top_15_songs, aes(x = reorder(Track, Spotify.Popularity), y = Spotify.Popularity)) +
      geom_point(size = 3, color = "green") +
      geom_segment(aes(x = Track, xend = Track, y = 0, yend = Spotify.Popularity), color = "green") +
      coord_flip() +
      theme_minimal() +
      labs(title = "Spotify Popularity of Top 15 Viral Songs",
           x = "Track",
           y = "Spotify Popularity")
    ggplotly(plot7)
  })
  
  output$github_link <- renderUI({
    tags$a(href = "https://github.com/your-repo/dataset", "GitHub Repository")
  })
})
