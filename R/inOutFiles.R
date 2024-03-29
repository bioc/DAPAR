
#' @title Saves the parameters of a tool in the pipeline of Prostar
#'
#' @param obj An object of class \code{MSnSet}
#'
#' @param name.dataset The name of the dataset
#'
#' @param name The name of the tool. Available values are: "Norm, Imputation,
#' anaDiff, GOAnalysis,Aggregation"
#'
#' @param l.params A list that contains the parameters
#'
#' @return An instance of class \code{MSnSet}.
#'
#' @author Samuel Wieczorek
#'
#' @examples
#' data(Exp1_R25_pept, package="DAPARdata")
#' l.params <- list(method = "Global quantile alignment", type = "overall")
#' saveParameters(Exp1_R25_pept, "Filtered.peptide", "Imputation", l.params)
#'
#' @export
#'
saveParameters <- function(
    obj, 
    name.dataset = NULL, 
    name = NULL, 
    l.params = NULL) {
    if (is.null(name) || is.null(name.dataset)) {
        warning("No operation has been applied to the dataset.")
        return(obj)
    }
    tmp <- list()
    if (is.null(l.params)) {
        tmp[[name]] <- list()
    } else {
        tmp[[name]] <- l.params
    }

    obj@experimentData@other$Params[[name.dataset]] <- tmp
    
    return(obj)
}



#' @title Creates an object of class \code{MSnSet} from text file
#' 
#' @description 
#' Builds an object of class \code{MSnSet} from a single tabulated-like file 
#' for quantitative and meta-data and a dataframe for the samples description. 
#' It differs from the original \code{MSnSet} builder which requires three 
#' separated files tabulated-like quantitative proteomic data into a 
#' \code{MSnSet} object, including metadata.
#'
#' @param file The name of a tab-separated file that contains the data.
#'
#' @param metadata A dataframe describing the samples (in lines).
#'
#' @param indExpData A vector of string where each element is the name
#' of a column in designTable that have to be integrated in
#' the \code{Biobase::fData()} table of the \code{MSnSet} object.
#'
#' @param colnameForID The name of the column containing the ID of entities
#' (peptides or proteins)
#'
#' @param indexForMetacell xxxxxxxxxxx
#'
#' @param logData A boolean value to indicate if the data have to be
#' log-transformed (Default is FALSE)
#'
#' @param replaceZeros A boolean value to indicate if the 0 and NaN values of
#' intensity have to be replaced by NA (Default is FALSE)
#'
#' @param pep_prot_data A string that indicates whether the dataset is about
#'
#' @param proteinId xxxx
#'
#' @param software xxx
#'
#' @return An instance of class \code{MSnSet}.
#'
#' @author Florence Combes, Samuel Wieczorek
#'
#' @examples
#' require(Matrix)
#' exprsFile <- system.file("extdata", "Exp1_R25_pept.txt", 
#' package = "DAPARdata")
#' metadataFile <- system.file("extdata", "samples_Exp1_R25.txt",
#'     package = "DAPARdata"
#' )
#' metadata <- read.table(metadataFile, header = TRUE, sep = "\t", 
#' as.is = TRUE)
#' indExpData <- seq.int(from=56, to=61)
#' colnameForID <- "id"
#' obj <- createMSnset(exprsFile, metadata, indExpData, colnameForID,
#'     indexForMetacell = seq.int(from=43, to=48), pep_prot_data = "peptide", 
#'     software = "maxquant"
#' )
#'
#'
#' exprsFile <- system.file("extdata", "Exp1_R25_pept.txt", 
#' package = "DAPARdata")
#' metadataFile <- system.file("extdata", "samples_Exp1_R25.txt", 
#' package = "DAPARdata")
#' metadata <- read.table(metadataFile, header = TRUE, sep = "\t", 
#' as.is = TRUE)
#' indExpData <- seq.int(from = 56, to = 61)
#' colnameForID <- "AutoID"
#' obj <- createMSnset(exprsFile, metadata, indExpData, colnameForID,
#' indexForMetacell = seq.int(from = 43, to = 48), 
#' pep_prot_data = "peptide", software = "maxquant"
#' )
#'
#' @export
#'
#' @importFrom MSnbase MSnSet
#' @importFrom utils read.table
#'
createMSnset <- function(file,
    metadata = NULL,
    indExpData,
    colnameForID = NULL,
    indexForMetacell = NULL,
    logData = FALSE,
    replaceZeros = FALSE,
    pep_prot_data = NULL,
    proteinId = NULL,
    software = NULL) {
    if (!is.data.frame(file)) { # the variable is a path to a text file
        data <- read.table(
            file, 
            header = TRUE, 
            sep = "\t", 
            stringsAsFactors = FALSE)
    } else {
        data <- file
    }

    colnames(data) <- gsub(".", "_", colnames(data), fixed = TRUE)
    colnameForID <- gsub(".", "_", colnameForID, fixed = TRUE)
    proteinId <- gsub(".", "_", proteinId, fixed = TRUE)
    colnames(data) <- gsub(" ", "_", colnames(data), fixed = TRUE)
    colnameForID <- gsub(" ", "_", colnameForID, fixed = TRUE)
    proteinId <- gsub(" ", "_", proteinId, fixed = TRUE)

    ## building exprs Data of MSnSet file
    Intensity <- matrix(
        as.numeric(gsub(",", ".", as.matrix(data[, indExpData]))),
        ncol = length(indExpData),
        byrow = FALSE
    )

    colnames(Intensity) <- gsub(".", "_", 
        colnames(data)[indExpData], 
        fixed = TRUE)
    rownames(Intensity) <- rownames(data)

    # Get the metacell info
    metacell <- NULL
    if (!is.null(indexForMetacell)) {
        metacell <- data[, indexForMetacell]
        metacell <- apply(metacell, 2, tolower)
        metacell <- as.data.frame(apply(metacell, 2, 
            function(x) gsub(" ", "", x)),
            stringsAsFactors = FALSE
        )
        colnames(metacell) <- gsub(".", "_", colnames(metacell), fixed = TRUE)
    }


    ## building fData of MSnSet file
    if (is.null(colnameForID)) {
        colnameForID <- "AutoID"
    }

    if (colnameForID == "AutoID") {
        fd <- data.frame(data,
            AutoID = rep(
                paste(pep_prot_data, "_", seq_len(nrow(data)), sep = "")),
            stringsAsFactors = FALSE
        )
        rownames(fd) <- paste(pep_prot_data, "_", seq_len(nrow(fd)), sep = "")
        rownames(Intensity) <- paste(pep_prot_data, "_",
            seq_len(nrow(Intensity)), sep = "")
    } else {
        fd <- data
        rownames(fd) <- data[, colnameForID]
        rownames(Intensity) <- data[, colnameForID]
    }

    colnames(fd) <- gsub(".", "_", colnames(fd), fixed = TRUE)

    pd <- as.data.frame(metadata, stringsAsFactors = FALSE)
    rownames(pd) <- gsub(".", "_", pd$Sample.name, fixed = TRUE)
    pd$Sample.name <- gsub(".", "_", pd$Sample.name, fixed = TRUE)

    ## Integrity tests
    if (identical(rownames(Intensity), rownames(fd)) == FALSE) {
        stop("Problem consistency betweenrow names expression data and 
            featureData")
    }

    if (identical(colnames(Intensity), rownames(pd)) == FALSE) {
        stop("Problem consistency between column names
            in expression data and row names in phenoData")
    }

    obj <- MSnSet(exprs = Intensity, fData = fd, pData = pd)



    if (replaceZeros) {
        Biobase::exprs(obj)[Biobase::exprs(obj) == 0] <- NA
        Biobase::exprs(obj)[is.nan(Biobase::exprs(obj))] <- NA
        Biobase::exprs(obj)[is.infinite(Biobase::exprs(obj))] <- NA
        obj@processingData@processing <- c(obj@processingData@processing, 
            "All zeros were replaced by NA")
    }
    if (logData) {
        Biobase::exprs(obj) <- log2(Biobase::exprs(obj))
        obj@processingData@processing <-
            c(obj@processingData@processing, "Data has been Log2 tranformed")
    }

    if (!is.null(pep_prot_data)) {
        obj@experimentData@other$typeOfData <- pep_prot_data
    }

    obj@experimentData@other$Prostar_Version <- NA
    tryCatch(
        {
            find.package("Prostar")
            .version <- installed.packages(lib.loc = Prostar.loc)["Prostar", "Version"]
            obj@experimentData@other$Prostar_Version <- .version
        },
        error = function(e) obj@experimentData@other$Prostar_Version <- NA
    )

    obj@experimentData@other$DAPAR_Version <- NA
    tryCatch(
        {
            find.package("DAPAR")
            .version <- installed.packages(lib.loc = Prostar.loc)["DAPAR", "Version"]
            obj@experimentData@other$DAPAR_Version <- .version
        },
        error = function(e) obj@experimentData@other$DAPAR_Version <- NA
    )

    obj@experimentData@other$proteinId <- proteinId
    obj@experimentData@other$keyId <- colnameForID

    obj@experimentData@other$RawPValues <- FALSE


    metacell <- BuildMetaCell(
        from = software,
        level = pep_prot_data,
        qdata = Biobase::exprs(obj),
        conds = Biobase::pData(obj)$Condition,
        df = metacell
    )
    colnames(metacell) <- gsub(".", "_", colnames(metacell), fixed = TRUE)

    Biobase::fData(obj) <- cbind(Biobase::fData(obj),
        metacell,
        deparse.level = 0
    )
    obj@experimentData@other$names_metacell <- colnames(metacell)


    return(obj)
}







#' @title Creates an object of class \code{MSnSet} from text file
#' 
#' @description 
#' Builds an object of class \code{MSnSet} from a single tabulated-like file 
#' for quantitative and meta-data and a dataframe for the samples description. 
#' It differs from the original \code{MSnSet} builder which requires three 
#' separated files tabulated-like quantitative proteomic data into a 
#' \code{MSnSet} object, including metadata.
#'
#' @param file The name of a tab-separated file that contains the data.
#'
#' @param metadata A dataframe describing the samples (in lines).
#'
#' @param qdataNames A vector of string where each element is the name
#' of a column in designTable that have to be integrated in
#' the \code{Biobase::fData()} table of the \code{MSnSet} object.
#'
#' @param colnameForID The name of the column containing the ID of entities
#' (peptides or proteins)
#'
#' @param metacellNames xxxxxxxxxxx
#'
#' @param logData A boolean value to indicate if the data have to be
#' log-transformed (Default is FALSE)
#'
#' @param replaceZeros A boolean value to indicate if the 0 and NaN values of
#' intensity have to be replaced by NA (Default is FALSE)
#'
#' @param pep_prot_data A string that indicates whether the dataset is about
#'
#' @param proteinId xxxx
#'
#' @param software xxx
#'
#' @return An instance of class \code{MSnSet}.
#'
#' @author Florence Combes, Samuel Wieczorek
#'
#' @examples
#' require(Matrix)
#' exprsFile <- system.file("extdata", "Exp1_R25_pept.txt", 
#' package = "DAPARdata")
#' metadataFile <- system.file("extdata", "samples_Exp1_R25.txt",
#'     package = "DAPARdata"
#' )
#' metadata <- read.table(metadataFile, header = TRUE, sep = "\t", 
#' as.is = TRUE)
#' indExpData <- seq.int(from=56, to=61)
#' colnameForID <- "id"
#' obj <- createMSnset(exprsFile, metadata, indExpData, colnameForID,
#'     indexForMetacell = seq.int(from=43, to=48), pep_prot_data = "peptide", 
#'     software = "maxquant"
#' )
#'
#'
#' exprsFile <- system.file("extdata", "Exp1_R25_pept.txt", 
#' package = "DAPARdata")
#' metadataFile <- system.file("extdata", "samples_Exp1_R25.txt", 
#' package = "DAPARdata")
#' metadata <- read.table(metadataFile, header = TRUE, sep = "\t", 
#' as.is = TRUE)
#' indExpData <- seq.int(from = 56, to = 61)
#' colnameForID <- "AutoID"
#' obj <- createMSnset(exprsFile, metadata, indExpData, colnameForID,
#' indexForMetacell = seq.int(from = 43, to = 48), 
#' pep_prot_data = "peptide", software = "maxquant"
#' )
#'
#' @export
#'
#' @importFrom MSnbase MSnSet
#' @importFrom utils read.table
#'
createMSnset2 <- function(file,
                          metadata = NULL,
                          qdataNames,
                          colnameForID = NULL,
                          metacellNames = NULL,
                          logData = FALSE,
                          replaceZeros = FALSE,
                          pep_prot_data = NULL,
                          proteinId = NULL,
                          software = NULL) {
  if (!is.data.frame(file)) { # the variable is a path to a text file
    data <- read.table(file, 
                       header = TRUE,
                       sep = "\t", 
                       stringsAsFactors = FALSE)
    } else {
    data <- file
    }
  
  colnames(data) <- gsub(".", "_", colnames(data), fixed = TRUE)
  colnameForID <- gsub(".", "_", colnameForID, fixed = TRUE)
  proteinId <- gsub(".", "_", proteinId, fixed = TRUE)
  colnames(data) <- gsub(" ", "_", colnames(data), fixed = TRUE)
  colnameForID <- gsub(" ", "_", colnameForID, fixed = TRUE)
  proteinId <- gsub(" ", "_", proteinId, fixed = TRUE)
  
  ## building exprs Data of MSnSet file
  Intensity <- matrix(
    as.numeric(gsub(",", ".", as.matrix(data[, qdataNames]))),
    ncol = length(qdataNames),
    byrow = FALSE
  )
  
  colnames(Intensity) <- gsub(".", "_", qdataNames, fixed = TRUE)
  rownames(Intensity) <- rownames(data)
  
  # Get the metacell info
  metacell <- NULL
  if (!is.null(metacellNames)) {
    metacell <- data[, metacellNames]
    metacell <- apply(metacell, 2, tolower)
    metacell <- as.data.frame(apply(metacell, 2, 
                                    function(x) gsub(" ", "", x)),
                              stringsAsFactors = FALSE
    )
    colnames(metacell) <- gsub(".", "_", colnames(metacell), fixed = TRUE)
  }
  
  
  ## building fData of MSnSet file
  if (is.null(colnameForID)) {
    colnameForID <- "AutoID"
  }
  
  if (colnameForID == "AutoID") {
    fd <- data.frame(data,
                     AutoID = rep(
                       paste(pep_prot_data, "_", seq_len(nrow(data)), sep = "")),
                     stringsAsFactors = FALSE
    )
    rownames(fd) <- paste(pep_prot_data, "_", seq_len(nrow(fd)), sep = "")
    rownames(Intensity) <- paste(pep_prot_data, "_",
                                 seq_len(nrow(Intensity)), sep = "")
  } else {
    fd <- data
    rownames(fd) <- data[, colnameForID]
    rownames(Intensity) <- data[, colnameForID]
  }
  
  colnames(fd) <- gsub(".", "_", colnames(fd), fixed = TRUE)
  
  pd <- as.data.frame(metadata, stringsAsFactors = FALSE)
  rownames(pd) <- gsub(".", "_", pd$Sample.name, fixed = TRUE)
  pd$Sample.name <- gsub(".", "_", pd$Sample.name, fixed = TRUE)
  
  ## Integrity tests
  if (identical(rownames(Intensity), rownames(fd)) == FALSE) {
    stop("Problem consistency betweenrow names expression data and 
            featureData")
  }
  
  if (identical(colnames(Intensity), rownames(pd)) == FALSE) {
    stop("Problem consistency between column names
            in expression data and row names in phenoData")
  }
  
  obj <- MSnSet(exprs = Intensity, fData = fd, pData = pd)
  
  
  
  if (replaceZeros) {
    Biobase::exprs(obj)[Biobase::exprs(obj) == 0] <- NA
    Biobase::exprs(obj)[is.nan(Biobase::exprs(obj))] <- NA
    Biobase::exprs(obj)[is.infinite(Biobase::exprs(obj))] <- NA
    obj@processingData@processing <- c(obj@processingData@processing, 
                                       "All zeros were replaced by NA")
  }
  if (logData) {
    Biobase::exprs(obj) <- log2(Biobase::exprs(obj))
    obj@processingData@processing <-
      c(obj@processingData@processing, "Data has been Log2 tranformed")
  }
  
  if (!is.null(pep_prot_data)) {
    obj@experimentData@other$typeOfData <- pep_prot_data
  }
  
  obj@experimentData@other$Prostar_Version <- NA
  tryCatch(
    {
      find.package("Prostar")
      .version <- installed.packages(lib.loc = Prostar.loc)["Prostar", "Version"]
      obj@experimentData@other$Prostar_Version <- .version
    },
    error = function(e) obj@experimentData@other$Prostar_Version <- NA
  )
  
  obj@experimentData@other$DAPAR_Version <- NA
  tryCatch(
    {
      find.package("DAPAR")
      .version <- installed.packages(lib.loc = Prostar.loc)["DAPAR", "Version"]
      obj@experimentData@other$DAPAR_Version <- .version
    },
    error = function(e) obj@experimentData@other$DAPAR_Version <- NA
  )
  
  obj@experimentData@other$proteinId <- proteinId
  obj@experimentData@other$keyId <- colnameForID
  
  obj@experimentData@other$RawPValues <- FALSE
  
  
  metacell <- BuildMetaCell(from = software,
                            level = pep_prot_data,
                            qdata = Biobase::exprs(obj),
                            conds = Biobase::pData(obj)$Condition,
                            df = metacell
                            )
  
  colnames(metacell) <- gsub(".", "_", colnames(metacell), fixed = TRUE)
  
  Biobase::fData(obj) <- cbind(Biobase::fData(obj),
                               metacell,
                               deparse.level = 0
  )
  obj@experimentData@other$names_metacell <- colnames(metacell)
  
  
  return(obj)
}






#' @title This function exports a data.frame to a Excel file.
#'
#' @param df An data.frame
#'
#' @param tags xxx
#'
#' @param colors xxx
#'
#' @param tabname xxx
#'
#' @param filename A character string for the name of the Excel file.
#'
#' @return A Excel file (.xlsx)
#'
#' @author Samuel Wieczorek
#'
#' @export
#'
#'
#' @examples
#' data(Exp1_R25_pept, package="DAPARdata")
#' df <- Biobase::exprs(Exp1_R25_pept[seq_len(100)])
#' tags <- GetMetacell(Exp1_R25_pept[seq_len(100)])
#' colors <- list(
#'     "Missing POV" = "lightblue",
#'     "Missing MEC" = "orange",
#'     "Quant. by recovery" = "lightgrey",
#'     "Quant. by direct id" = "white",
#'     "Combined tags" = "red"
#' )
#' write.excel(df, tags, colors, filename = "toto")
#' 
write.excel <- function(df,
    tags = NULL,
    colors = NULL,
    tabname = "foo",
    filename = NULL) {
    pkgs.require(c('openxlsx', 'tools'))
    
    if (is.null(filename)) {
        filename <- paste("data-", Sys.Date(), ".xlxs", sep = "")
    } else if (tools::file_ext(filename) != "") {
        if (tools::file_ext(filename) != "xlsx") {
            stop("Filename extension must be equal to 'xlsx'. Abort...")
        } else {
            fname <- filename
        }
    } else {
        fname <- paste(filename, ".xlsx", sep = "")
    }

    unique.tags <- NULL
    if (!is.null(tags) && !is.null(colors)) {
        unique.tags <- unique(as.vector(as.matrix(tags)))
        if (!isTRUE(
            sum(unique.tags %in% names(colors)) == length(unique.tags))) {
            warning("The length of colors vector must be equal to the number 
            of different tags. As is it not the case, colors are ignored")
        }
    }

    wb <- openxlsx::createWorkbook(fname)
    openxlsx::addWorksheet(wb, tabname)
    openxlsx::writeData(wb, sheet = 1, df, rowNames = FALSE)


    # Add colors w.r.t. tags
    if (!is.null(tags) && !is.null(colors)) {
        if (isTRUE(
            sum(
                unique.tags %in% names(colors)) == length(unique.tags)
            )
            ) {
            lapply(seq_len(length(colors)), function(x) {
                list.tags <- which(names(colors)[x] == tags, arr.ind = TRUE)
                openxlsx::addStyle(wb,
                    sheet = 1,
                    cols = list.tags[, "col"],
                    rows = list.tags[, "row"] + 1,
                    style = openxlsx::createStyle(fgFill = colors[x])
                )
            })
        }
    }

    openxlsx::saveWorkbook(wb, fname, overwrite = TRUE)
}



#'
#' @title This function exports a \code{MSnSet} object to a Excel file.
#' 
#' @description 
#' This function exports a \code{MSnSet} data object to a Excel file.
#' Each of the three data.frames in the \code{MSnSet} object (ie experimental
#' data, phenoData and metaData are respectively integrated into separate sheets
#' in the Excel file). 
#' 
#' The colored cells in the experimental data correspond to the original
#' missing values which have been imputed.
#'
#' @param obj An object of class \code{MSnSet}.
#'
#' @param filename A character string for the name of the Excel file.
#'
#' @return A Excel file (.xlsx)
#'
#' @author Samuel Wieczorek
#'
#' @examples
#' Sys.setenv("R_ZIPCMD" = Sys.which("zip"))
#' data(Exp1_R25_pept, package="DAPARdata")
#' obj <- Exp1_R25_pept[seq_len(10)]
#' writeMSnsetToExcel(obj, "foo")
#' 
#'
#' @export
#'
#'
writeMSnsetToExcel <- function(obj, filename) {
    pkgs.require(c('stats', 'openxlsx'))

    name <- paste(filename, ".xlsx", sep = "")
    wb <- openxlsx::createWorkbook(name)
    n <- 1
    openxlsx::addWorksheet(wb, "Quantitative Data")
    openxlsx::writeData(wb, sheet = n, cbind(
        ID = rownames(Biobase::exprs(obj)),
        Biobase::exprs(obj)
    ), rowNames = FALSE)


    # Add colors to quantitative table
    mc <- metacell.def(GetTypeofData(obj))
    colors <- as.list(stats::setNames(mc$color, mc$node))
    tags <- cbind(
        keyId = rep("Quant. by direct id", nrow(obj)),
        GetMetacell(obj)
    )


    unique.tags <- NULL
    if (!is.null(tags) && !is.null(colors)) {
        unique.tags <- unique(as.vector(as.matrix(tags)))
        if (!isTRUE(
            sum(unique.tags %in% names(colors)) == length(unique.tags))) {
            warning("The length of colors vector must be equal to the number 
            of different tags. As is it not the case, colors are ignored")
            }
        if (isTRUE(
            sum(unique.tags %in% names(colors)) == length(unique.tags))) {
            lapply(seq_len(length(colors)), function(x) {
                list.tags <- which(names(colors)[x] == tags, arr.ind = TRUE)
                openxlsx::addStyle(wb,
                    sheet = 1,
                    cols = list.tags[, "col"],
                    rows = list.tags[, "row"] + 1,
                    style = openxlsx::createStyle(fgFill = colors[x])
                )
            })
        }
    }


    n <- 2
    openxlsx::addWorksheet(wb, "Samples Meta Data")
    openxlsx::writeData(wb, sheet = n, Biobase::pData(obj), rowNames = FALSE)


    # Add colors for sample data sheet
    u_conds <- unique(Biobase::pData(obj)$Condition)
    colors <- stats::setNames(
        ExtendPalette(length(u_conds)),
        u_conds
    )
    colors[["blank"]] <- "white"

    tags <- Biobase::pData(obj)
    tags[, ] <- "blank"
    tags$Sample.name <- Biobase::pData(obj)$Condition
    tags$Condition <- Biobase::pData(obj)$Condition

    unique.tags <- NULL
    if (!is.null(tags) && !is.null(colors)) {
        unique.tags <- unique(as.vector(as.matrix(tags)))
        if (!isTRUE(
            sum(unique.tags %in% names(colors)) == length(unique.tags))) {
            warning("The length of colors vector must be equal to the number 
            of different tags. As is it not the case, colors are ignored")
        }
        if (isTRUE(
            sum(unique.tags %in% names(colors)) == length(unique.tags))) {
            lapply(seq_len(length(colors)), function(x) {
                list.tags <- which(names(colors)[x] == tags, arr.ind = TRUE)
                openxlsx::addStyle(wb,
                    sheet = n,
                    cols = list.tags[, "col"],
                    rows = list.tags[, "row"] + 1,
                    style = openxlsx::createStyle(fgFill = colors[x])
                )
            })
        }
    }


    ## Add feature Data sheet

    n <- 3
    if (dim(Biobase::fData(obj))[2] != 0) {
        openxlsx::addWorksheet(wb, "Feature Meta Data")
        openxlsx::writeData(wb,
            sheet = n,
            cbind(
                ID = rownames(Biobase::fData(obj)),
                Biobase::fData(obj)
            ), rowNames = FALSE
        )
    }

    colors <- as.list(stats::setNames(mc$color, mc$node))
    tags <- cbind(
        keyId = rep("Quant. by direct id", nrow(obj)),
        Biobase::fData(obj)
    )

    .ind <- colnames(Biobase::fData(obj))
    .ind <- which(.ind %in% obj@experimentData@other$names_metacell)
    tags[, ] <- "Quant. by direct id"
    tags[, 1 + .ind] <- GetMetacell(obj)

    unique.tags <- NULL
    if (!is.null(tags) && !is.null(colors)) {
        unique.tags <- unique(as.vector(as.matrix(tags)))
        if (!isTRUE(
            sum(unique.tags %in% names(colors)) == length(unique.tags))) {
            warning("The length of colors vector must be equal to the number 
            of different tags. As is it not the case, colors are ignored")
        }
        if (isTRUE(
            sum(unique.tags %in% names(colors)) == length(unique.tags))) {
            lapply(seq_len(length(colors)), function(x) {
                list.tags <- which(names(colors)[x] == tags, arr.ind = TRUE)
                openxlsx::addStyle(wb,
                    sheet = n,
                    cols = list.tags[, "col"],
                    rows = list.tags[, "row"] + 1,
                    style = openxlsx::createStyle(fgFill = colors[x])
                )
            })
        }
    }

    # Add GO tab
    if (!is.null(obj@experimentData@other$GGO_analysis)) {
        l <- length(obj@experimentData@other$GGO_analysis$ggo_res)
        for (i in seq_len(l)) {
            n <- n + 1
            level <- as.numeric(
                obj@experimentData@other$GGO_analysis$levels[i])
            openxlsx::addWorksheet(wb, 
                paste("Group GO - level ", level, sep = ""))
            .other <- obj@experimentData@other
            .dat <- .other$GGO_analysis$ggo_res[[i]]$ggo_res@result
            openxlsx::writeData(wb, sheet = n, .dat)
        }
    }



    if (!is.null(obj@experimentData@other$EGO_analysis)) {
        n <- n + 1
        openxlsx::addWorksheet(wb, "Enrichment GO")
        openxlsx::writeData(
            wb, 
            sheet = n, 
            obj@experimentData@other$EGO_analysis$ego_res@result)
    }

    openxlsx::saveWorkbook(wb, name, overwrite = TRUE)
    return(name)
}




#' @title This function reads a sheet of an Excel file and put the data
#' into a data.frame.
#'
#' @param file The name of the Excel file.
#'
#' @param sheet The name of the sheet
#'
#' @return A data.frame
#'
#' @author Samuel Wieczorek
#'
#' @export
#' 
#' @examples 
#' NULL
#'
#'
readExcel <- function(file, sheet=NULL) {
    pkgs.require('readxl')

  if(is.null(sheet))
    return(NULL)
  
    data <- NULL
    data <- readxl::read_excel(file, 
                               sheet,
                               col_types = 'guess')

    return(
        as.data.frame(
            data, 
            asIs = TRUE, 
            stringsAsFactors = FALSE
            )
        )
}



#' @title This function returns the list of the sheets names in a Excel file.
#'
#' @param file The name of the Excel file.
#'
#' @return A vector
#'
#' @author Samuel Wieczorek
#'
#' @export
#' 
#' @examples 
#' NULL
#'
#'
listSheets <- function(file) {
    pkgs.require('openxlsx')
    return(openxlsx::getSheetNames(file))
}


#' @title Exports a MSnset dataset into a zip archive containing three
#' zipped CSV files.
#'
#' @param obj An object of class \code{MSnSet}.
#'
#' @param fname The name of the archive file.
#'
#' @return A compressed file
#'
#' @author Samuel Wieczorek
#'
#' @examples
#' data(Exp1_R25_pept, package="DAPARdata")
#' obj <- Exp1_R25_pept[seq_len(10)]
#' writeMSnsetToCSV(obj, "foo")
#'
#' @export
#'
#' @importFrom utils write.csv zip
#'
writeMSnsetToCSV <- function(obj, fname) {


    write.csv(Biobase::exprs(obj), paste(tempdir(), "exprs.csv", sep = "/"))
    write.csv(Biobase::fData(obj), paste(tempdir(), "fData.csv", sep = "/"))
    write.csv(Biobase::pData(obj), paste(tempdir(), "pData.csv", sep = "/"))
    files <- c(
        paste(tempdir(), "exprs.csv", sep = "/"),
        paste(tempdir(), "fData.csv", sep = "/"),
        paste(tempdir(), "pData.csv", sep = "/")
    )
    zip(fname, files, zip = Sys.getenv("R_ZIPCMD", "zip"))

    return(fname)
}



#' @title Similar to the function \code{rbind} but applies on two subsets of
#' the same \code{MSnSet} object.
#'
#' @param df1 An object (or subset of) of class \code{MSnSet}. May be NULL
#'
#' @param df2 A subset of the same object as df1
#'
#' @return An instance of class \code{MSnSet}.
#'
#' @author Samuel Wieczorek
#'
#' @examples
#' data(Exp1_R25_pept, package="DAPARdata")
#' df1 <- Exp1_R25_pept[seq_len(100)]
#' df2 <- Exp1_R25_pept[seq.int(from = 200, to = 250)]
#' rbindMSnset(df1, df2)
#'
#' @export
#'
rbindMSnset <- function(df1 = NULL, df2) {
    if (is.null(df1)) {
        obj <- df2
        return(obj)
    }
    
    if (is.null(df1) && is.null(df2)) {
        return(NULL)
    }

    tmp.exprs <- rbind(Biobase::exprs(df1), Biobase::exprs(df2))
    tmp.fData <- rbind(Biobase::fData(df1), Biobase::fData(df2))
    tmp.pData <- Biobase::pData(df1)

    obj <- MSnbase::MSnSet(
        exprs = tmp.exprs, 
        fData = tmp.fData, 
        pData = tmp.pData
        )
    obj@protocolData <- df1@protocolData
    obj@experimentData <- df1@experimentData

    return(obj)
}
