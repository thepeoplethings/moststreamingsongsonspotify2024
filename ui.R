ui <- dashboardPage(
  skin = "green",
  
  dashboardHeader(title = "Spotify Data Visualization"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem(text = "Overview", tabName = "overview", icon = icon("dashboard")),
      menuItem(text = "Top 10 Most Streamed Artists", tabName = "top_artists", icon = icon("music")),
      menuItem(text = "Top 10 Most Streamed K-Pop Artists", tabName = "top_kpop_artists", icon = icon("music")),
      menuItem(text = "Top 15 Most Used Viral Songs on TikTok", tabName = "top_tiktok_songs", icon = icon("tiktok")),
      menuItem(text = "Datasets", tabName = "datasets", icon = icon("database"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "overview",
        fluidRow(
          infoBox(
            title = "Total Streams", 
            value = total_streams, 
            width = 6, 
            color = "aqua",
            icon = icon("headphones")
          ),
          infoBox(
            title = "Total YouTube Views", 
            value = total_youtube_views, 
            width = 6, 
            color = "red",
            icon = icon("youtube")
          )
        ),
        fluidRow(
          box(width = 12, 
              plotlyOutput(
                outputId = "top_songs_plot"))
        )
      ),
      
      tabItem(
        tabName = "top_artists",
        fluidRow(
          box(width = 12, 
              plotlyOutput(outputId = "top_artists_plot"))
        ),
        fluidRow(
          box(width = 12, 
              selectInput(
                inputId = "selected_artist", 
                choices = unique(spotify_data$Artist), 
                label = "Select Artist"))
        ),
        fluidRow(
          box(width = 12, 
              plotlyOutput(
                outputId = "youtube_tiktok_plot_artist"))
        )
      ),
      
      tabItem(
        tabName = "top_kpop_artists",
        fluidRow(
          box(width = 12, 
              plotlyOutput(
                outputId = "top_kpop_artists_plot"))
        ),
        fluidRow(
          box(width = 12, 
              selectInput(inputId = "selected_kpop_artist", 
                          choices = unique(spotify_data$Artist), 
                          label = "Select K-Pop Artist"))
        ),
        fluidRow(
          box(width = 12, 
              plotlyOutput(
                outputId = "youtube_views_plot_kpop_artist"))
        )
      ),
      
      tabItem(
        tabName = "top_tiktok_songs",
        fluidRow(
          box(width = 12, 
              plotlyOutput(
                outputId = "top_tiktok_songs_plot"))
        ),
        fluidRow(
          box(width = 12, 
              plotlyOutput(
                outputId = "spotify_popularity_plot"))
        )
      ),
      
      tabItem(
        tabName = "datasets",
        h2("Datasets"),
        p("Link to datasets on GitHub:"),
        uiOutput("github_link")
      )
    )
  )
)
