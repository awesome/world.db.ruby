# encoding: UTF-8

module WorldDb

module Matcher

  def match_xxx_for_country( name, xxx )  # xxx e.g. cities|regions|beers|breweries
    #      auto-add required country code (from folder structure)
    #  note: always let match_xxx_for_country_n_region go first

    # note: allow  /cities and /1--hokkaido--cities
    xxx_pattern = "(?:#{xxx}|[0-9]+--[^\\/]+?--#{xxx})"    # note: double escape \\ required for backslash

    if name =~ /(?:^|\/)([a-z]{2,3})-[^\/]+\/#{xxx_pattern}/         ||    # (1)
       name =~ /(?:^|\/)[0-9]+--([a-z]{2,3})-[^\/]+\/#{xxx_pattern}/ ||    # (2)
       name =~ /(?:^|\/)([a-z]{2,3})\/#{xxx_pattern}/                ||    # (3)
       name =~ /(?:^|\/)([a-z]{2,3})-[^\/]+\/[0-9]+--[^\/]+\/#{xxx_pattern}/    # (4)

      country_key = $1.dup
      yield( country_key )
      true # bingo - match found
      
      ######
      # (1)  new style: e.g. /at-austria/beers or ^at-austria!/cities
      #
      # (2)  new-new style e.g. /1--at-austria--central/cities
      #
      # (3)  classic style: e.g. /at/beers (europe/at/cities)
      #
      # (4) new style w/ region w/o abbrev/code e.g. /ja-japon/1--hokkaido/cities
    else
      false # no match found
    end
  end


  def match_xxx_for_country_n_region( name, xxx ) # xxx e.g. wine|wineries

    # auto-add required country n region code (from folder structure)

    ## -- allow opt_folders after long regions (e.g. additional subregion/zone)
    ## -- allow anything (prefixes) before -- for xxx
    #       e.g.  at-austria!/1--n-niederoesterreich--eastern/wagram--wines
    #             at-austria!/1--n-niederoesterreich--eastern/wagram--wagram--wines

    # note: allow  /cities and /1--hokkaido--cities and /hokkaido--cities too
    xxx_pattern = "(?:#{xxx}|[^\\/]+--#{xxx})"    # note: double escape \\ required for backslash
    
    ## allow optional folders -- TODO: add restriction ?? e.g. must be 4+ alphas ???
    opt_folders_pattern = "(?:\/[^\/]+)*"
    ## note: for now only (style #2) n (style #3)  that is long region allow opt folders

    if name =~ /(?:^|\/)([a-z]{2,3})-[^\/]+\/([a-z]{1,3})-[^\/]+\/#{xxx_pattern}/  ||                # (1)
       name =~ /(?:^|\/)[0-9]+--([a-z]{2,3})-[^\/]+\/[0-9]+--([a-z]{1,3})-[^\/]+#{opt_folders_pattern}\/#{xxx_pattern}/ || # (2)
       name =~ /(?:^|\/)([a-z]{2,3})-[^\/]+\/[0-9]+--([a-z]{1,3})-[^\/]+#{opt_folders_pattern}\/#{xxx_pattern}/         || # (3)
       name =~ /(?:^|\/)[0-9]+--([a-z]{2,3})-[^\/]+\/([a-z]{1,3})-[^\/]+\/#{xxx_pattern}/            # (4)

      #######
      # nb: country must start name (^) or coming after / e.g. europe/at-austria/...
      # (1)
      # new style: e.g.  /at-austria/w-wien/cities or
      #                  ^at-austria!/w-wien/cities
      # (2)
      # new new style e.g.  /1--at-austria--central/1--w-wien--eastern/cities
      #
      # (3)
      #  new new mixed style e.g.  /at-austria/1--w-wien--eastern/cities
      #      "classic" country plus new new region
      #
      # (4)
      #  new new mixed style e.g.  /1--at-austria--central/w-wien/cities
      #      new new country plus "classic" region

      country_key = $1.dup
      region_key  = $2.dup
      yield( country_key, region_key )
      true # bingo - match found
    else
      false # no match found
    end
  end


  def match_cities_for_country( name, &blk )
    ## todo: check if there's a better (more ruby way) to pass along code block ??
    ## e.g. try
    ##   match_xxx_for_country( name, 'cities') { |country_key| yield(country_key) }

    match_xxx_for_country( name, 'cities', &blk )
  end

  def match_regions_for_country( name, &blk )
    ## todo: check if there's a better (more ruby way) to pass along code block ??
    match_xxx_for_country( name, 'regions', &blk )
  end

  def match_regions_abbr_for_country( name, &blk )
    match_xxx_for_country( name, 'regions\.abbr', &blk )  # NB: . gets escaped for regex, that is, \.
  end

  def match_regions_iso_for_country( name, &blk )  # NB: . gets escaped for regex, that is, \.
    match_xxx_for_country( name, 'regions\.iso', &blk )
  end

  def match_regions_nuts_for_country( name, &blk )  # NB: . gets escaped for regex, that is, \.
    match_xxx_for_country( name, 'regions\.nuts', &blk )
  end


  def match_countries_for_continent( name )
    if name =~ /^([a-z][a-z\-_]+[a-z])\/countries/     # e.g. africa/countries or america/countries
      ### NB: continent changed to regions (e.g. middle-east, caribbean, north-america, etc.)
      ## auto-add continent (from folder structure) as tag
      ## fix: allow dash/hyphen/minus in tag
      continent = $1.dup
      yield( continent )
      true
    else
      false # no match found
    end
  end

end # module Matcher

end # module WorldDb
