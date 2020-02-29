library(shiny)
library(shinydashboard)

ui <- dashboardPage(
	dashboardHeader(title = "Set"),
	dashboardSidebar(
		sidebarSearchForm(label = "Search...", "searchText", "searchButton"),
		tags$head(tags$script(HTML("
      Shiny.addCustomMessageHandler('manipulateMenuItem', function(message){
        var aNodeList = document.getElementsByTagName('a');

        for (var i = 0; i < aNodeList.length; i++) {
          if(aNodeList[i].getAttribute('data-value') == message.tabName) {
            if(message.action == 'hide'){
              aNodeList[i].setAttribute('style', 'display: none;');
            } else {
              aNodeList[i].setAttribute('style', 'display: block;');
            };
          };
        }
      });
    "))),
		sidebarMenu(
			menuItem("Port", tabName = "P", icon = icon("cog")),
			menuItem("Rank", tabName = "Rank", icon = icon("cog")),
			menuItem("Mark", tabName = "Mark", icon = icon("bar-chart")),
			menuItem("Read", tabName = "Read", icon = icon("file-pdf-o")),
			menuItem("Port", tabName = "Ocean", icon = icon("heart"))
		),
		uiOutput('Super'),
		uiOutput('AList'),
		uiOutput('BList'),
		uiOutput('DList'),
		uiOutput('SList')
	),
	dashboardBody(
		textInput("user", "User ID fake.")
	)
)

server <- function(input, output, session) {
	observeEvent(input$user,{
		if(input$user != "tester"){
			session$sendCustomMessage(type = "manipulateMenuItem", message = list(action = "hide", tabName = "P"))
		}else{
			session$sendCustomMessage(type = "manipulateMenuItem", message = list(action = "show", tabName = "P"))
		}
	})
}

shinyApp(ui, server)
