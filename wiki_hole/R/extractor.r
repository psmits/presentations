get.info <- function(xml) {
  tit <- xmlToList(xml[['title']])[[1]]
  tit <- tolower(str_trim(str_extract(tit, '([^\\(]*)')))

  if(!is.na(str_match(tit, 'memory alpha'))) {
    return('bad page')
  }
  if(!is.na(str_match(tit, 'user'))) {
    return('bad page')
  }
  if(!is.na(str_match(tit, 'talk\\:'))) {
    return('bad page')
  }
  if(!is.na(str_match(tit, 'mediawiki'))) {
    return('bad page')
  }
  if(!is.na(str_match(tit, 'help\\:'))) {
    return('bad page')
  }
  if(!is.na(str_match(tit, 'forum\\:'))) {
    return('bad page')
  }
  if(!is.na(str_match(tit, 'file\\:'))) {
    return('bad page')
  }
  if(!is.na(str_match(tit, 'template\\:'))) {
    return('bad page')
  }
  if(!is.na(str_match(tit, 'category\\:'))) {
    return('bad page')
  }

  txt <- xml[['revision']][['text']]
  oo <- xmlToList(txt[['text']])[[1]]

  oo <- tolower(oo)
  if(!is.na(str_match(oo, '\\#redirect'))) {
    return('bad page')
  }

  rr <- str_split(oo, '===')[[1]]  # sections de deliminated this way
  if(length(rr) < 1) {
    tit.num <- seq(from = 2, to = length(rr), by = 2)
    sec.tit <- rr[tit.num]  # section titles
    # bad sections
    bad <- seq(which(sec.tit == 'cast'))
    tt <- rr[(tit.num[bad] - 1)]
  } else {
    tt <- rr
  }

  # get all the links in a section
  # got to clear out all the bad links and shity bits of them
  links <- unique(do.call(c, str_extract_all(tt, '\\[\\[(.*?)\\]\\]')))
  links <- laply(links, function(x) str_sub(x, start = 3, end = -3))
  links <- links[laply(links, function(x) is.na(str_match(x, 'file\\:')))]
  links <- links[laply(links, function(x) is.na(str_match(x, 'jpg')))]
  links <- str_trim(laply(links, function(x) str_extract(x, '([^\\|]*)')))

  out <- list()
  out$title <- tit
  out$links <- links
  out
}

