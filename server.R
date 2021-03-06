library(shiny)
library(DT)
library(htmlwidgets)
library(shinydashboard)

shinyServer(function(input, output, session) {

	filteredData <- reactive({
		if (input$filterZeroPrevalence) {
			return(results[results$Prevalence != "0",])
		} else {
			return(results)
		}
	})

	keyToRows <- reactive({
	  formula <- as.formula(paste("ID ~", input$aggregateKey))
		aggregate(formula, data = filteredData(), length)
	})

	output$allResultsTable <- renderDT({
		table <- filteredData()
		selected <- input$perAggregateKey_rows_selected
		if (!is.null(selected)) {
			keys <- keyToRows()[, 1]
			table <- table[table[, input$aggregateKey] == keys[selected], ]
		}
		return(table)
	},
	server = TRUE,
	caption = paste0(
		"Table 1: Comparison of ",
		oldVersion,
		" (Old) versus ",
		newVersion,
		" (New)"
	),
	filter = list(position = 'top'),
	extensions = 'Buttons',
	rowname = FALSE,
	selection = 'single',
	options = list(
		autoWidth = FALSE,
		lengthMenu = list( c(5,10, 25, 50, 75, 100, -1), c(5,10,25,50,75,100,"All")),
		searchHighlight = TRUE,
		dom = 'Blfrtip',
		buttons =
				list(I('colvis'), "copy", list(
					extend = "collection"
					, buttons = c("csv", "excel")
					, text = "Download"
		)),

		columnDefs = list(
			list(targets = c(0,2), visible = FALSE),
			list(
			targets = 3,
			render = JS(
				"function(data, type, row, meta) {",
				"return type === 'display' && data.length > 0 ?",
				"'<a target = \"_blank\" href=\"http://athena.ohdsi.org/search-terms/terms/' + data + '\" >' + data + ' </a>' : data;",
				"}"
			)
		))
	))

	output$perAggregateKey <- renderDT({
		table <- keyToRows()
		color <- "green"
		names(table)[2] <- "rows"
		return(table)
	},
	rowname = TRUE,
	selection = 'single',
	options = list(lengthChange = TRUE,
										searching = TRUE))

	output$label = renderPrint({
		s = input$perAggregateKey_row_last_clicked
		if (length(s)) {
			cat('These rows were selected:\n\n')
			print(s)
			print(keyToRows()[s, 1])
		}
	})

	output$showSummary = reactive({showSummary})

})
