module.exports = (grunt) ->
  
  # Project configuration
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    
    concat:
      options:
        stripBanners: true
        banner: "/*! <%= pkg.title %> - v<%= pkg.version %>\n" + " * <%= pkg.homepage %>\n" + " * Copyright (c) <%= grunt.template.today(\"yyyy\") %>;" + " * Licensed GPLv2+" + " */\n"

      thermochromism:
        src: ["assets/js/src/thermochromism.js"]
        dest: "assets/js/thermochromism.js"
        
    bower_concat:
      all:
        dest: 'assets/js/bower.js'

    jshint:
      all: [
        "Gruntfile.js"
        "assets/js/src/**/*.js"
        "assets/js/test/**/*.js"
      ]
      options:
        curly: true
        eqeqeq: true
        immed: true
        latedef: true
        newcap: true
        noarg: true
        sub: true
        undef: true
        boss: true
        eqnull: true
        globals:
          exports: true
          module: false

    uglify:
      all:
        files:
          "assets/js/thermochromism.min.js": ["assets/js/thermochromism.js"]

        options:
          banner: "/*! <%= pkg.title %> - v<%= pkg.version %>\n" + " * <%= pkg.homepage %>\n" + " * Copyright (c) <%= grunt.template.today(\"yyyy\") %>;" + " * Licensed GPLv2+" + " */\n"
          mangle: except: ["jQuery"]
          
      bower: 
        options: mangle: false, compress: true
        files: 'assets/js/bower.min.js': 'assets/js/bower.js'
        
    test:
      files: ["assets/js/test/**/*.js"]

    less:
      all:
        files:
          "assets/css/thermochromism.css": "assets/css/less/thermochromism.less"
                  
    cssmin:
      options:
        banner: "/*! <%= pkg.title %> - v<%= pkg.version %>\n" + " * <%= pkg.homepage %>\n" + " * Copyright (c) <%= grunt.template.today(\"yyyy\") %>;" + " * Licensed GPLv2+" + " */\n"

      minify:
        expand: true
        cwd: "assets/css/"
        src: ["thermochromism.css"]
        dest: "assets/css/"
        ext: ".min.css"

    watch:
      less:
        files: ["assets/css/less/*.less"]
        tasks: [
          "less"
          "cssmin"
        ]
        options:
          debounceDelay: 500

      scripts:
        files: [
          "assets/js/src/**/*.js"
          "assets/js/vendor/**/*.js"
        ]
        tasks: [
          "jshint"
          "concat"
          "uglify"
        ]
        options:
          debounceDelay: 500

    clean:
      main: ["release/<%= pkg.version %>"]

    copy:
      
      # Copy the plugin to a versioned release directory
      main:
        src: [
          "**"
          "!node_modules/**"
          "!release/**"
          "!.git/**"
          "!.sass-cache/**"
          "!css/src/**"
          "!js/src/**"
          "!img/src/**"
          "!Gruntfile.js"
          "!package.json"
          "!.gitignore"
          "!.gitmodules"
        ]
        dest: "release/<%= pkg.version %>/"

    compress:
      main:
        options:
          mode: "zip"
          archive: "./release/thermochromism.<%= pkg.version %>.zip"

        expand: true
        cwd: "release/<%= pkg.version %>/"
        src: ["**/*"]
        dest: "thermochromism/"

  
  # Load all other tasks
  require("load-grunt-tasks") grunt
  
  # Default task.
  grunt.registerTask "default", [
    "jshint"
    "concat"
    "uglify"
    "less"
    "cssmin"
  ]
  
  grunt.registerTask 'buildbower', [
    'bower_concat',
    'uglify:bower'
  ]
  
  grunt.registerTask "build", [
    "default"
    "clean"
    "copy"
    "compress"
  ]
  
  grunt.util.linefeed = "\n"
