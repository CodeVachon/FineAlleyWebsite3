module.exports = function(grunt) {
	// Project configuration.
	var _banner = '/** \n* Package: <%= pkg.name %> \n* Author: <%= pkg.developer %> \n* Build Time: <%= grunt.template.today("yyyy-mm-dd HH:MM:ss") %>  \n*/\n';

	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		jshint: {
			options: {
				globals: {
					jQuery: true,
					console: true,
					module: true
				} // close .globals
			}, // close .options
			file: {
				src: ['gruntfile.js'],
			}, // close .file
			build: {
				src: ['src/js/*.js'],
			} // close .build
		}, // close jshint
		uglify: {
			options: {
				banner: _banner,
				mangle: {
					except: ['jQuery', 'Backbone']
				}
			}, // close .options
			file: {
				files: [{'gruntfile.min.js': ['gruntfile.js']}]
			}, // close .file
			build: {
				files: [{
					cwd: 'src/js',
					expand: true,
					src: ['*.js'],
					dest: 'includes/js/',
					ext: '.min.js'
				}]
			}, // close .build
		}, // close uglify
		csslint: {
			options: {
				"import": 2,
				"important": false,
				"ids": false,
				"adjoining-classes": false,
				"qualified-headings": false,
				"overqualified-elements": false,
				"unique-headings": false,
				"duplicate-background-images": false,
				"compatible-vendor-prefixes": false,
				"gradients": false
			}, // close .options 
			file: {
				src: ['src/css/main.css']
			}, // close .file
			build: {
				src: ['src/css/*.css']
			} // close .build
		}, // close csslint
		cssmin: {
			options: {
				banner: _banner,
			}, // close .options
			file: {
				files: {'src/css/main.min.css': ['src/css/main.css']}
			}, // close .file
			build: {
				files: [{
					cwd: 'src/css',
					expand: true,
					src: ['*.css'],
					dest: 'includes/css/',
					ext: '.min.css'
				}]
			}, // close .build
		}, // close cssmin
		less: {
			options: {
				banner: '/** \n* Package: <%= pkg.name %> \n* Author: <%= pkg.developer %> \n* Build Time: <%= grunt.template.today("yyyy-mm-dd HH:MM:ss") %>  \n* Compiled From Less Files \n */\n'
			},
			file: {
				files: {'src/css/main.min.css': ['src/css/main.css']}
			}, // close .file
			build: {
				files: [{
					cwd: 'src/less',
					expand: true,
					src: ['*.less'],
					dest: 'src/css/',
					ext: '.css'
				}]
			}, // close .build
		}, // close less
		watch: {
			gruntFile: {
				files: ['gruntfile.js'],
				tasks: ['jshint:file']
			}, // close .gruntFile
			jsCompile: {
				files: ['src/js/*.js','!src/js/*.min.js'],
				tasks: ['jshint:file','uglify:file'],
				options: {
					spawn: false,
					nospawn: true
				} // close .options
			}, // close .jsCompile
			cssCompile: {
				files: ['src/css/*.css','!src/css/*.min.css'],
				tasks: ['cssmin:file'],//'csslint:file',
				options: {
					spawn: false,
					nospawn: true
				} // close .options
			}, // close .cssCompile
			lessCompile: {
				files: ['src/less/*.less'],
				tasks: ['less:file','cssmin:file'], // ,'csslint:file'
				options: {
					spawn: false,
					nospawn: true
				} // close .options
			} // close .lessCompile
		}, // close watch
		copy: {
			dist: {
				files: [
					{
						expand: true, 
						src: ['controllers/**','layouts/**','models/**','frameworkOne/**','includes/**','services/**','views/**'], 
						dest: 'dest/',
						noProcess: 'views/build/*'
					},
					{
						src: ['application.cfc','favicon.ico','index.cfm','robots.txt','**.html'],
						dest: 'dest/'
					}
				]
			}
		}, // close copy
		'ftp-deploy': {
			deploy: {
				auth: {
					host: 'ftp.finealley.com',
					port: 21,
					authKey: 'finealley'
				},
				src: 'dest/',
				dest: '/wwwroot',
				exclusions: ['dest/**/.DS_Store', 'dest/**/Thumbs.db', 'dest/**/build', 'dest/includes/js/tinymce/**']
			}
		}, // close ftp-deploy
		gitcommit: {
			dist: {
				options: {
					message: 'Distribution Changes',
					ignoreEmpty: true // dont fail on no changes
				},
				files: {
					src: ['dest/**']
				}
			}
		}, // close gitcommit
		http: {
			reload: {
				options: {
					url: 'http://finealley.com/?arma-iterum=onere',
				},
			}
		} // close http
	}); // close grunt.initConfig

	grunt.loadNpmTasks('grunt-contrib-jshint');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-csslint');
	grunt.loadNpmTasks('grunt-contrib-cssmin');
	grunt.loadNpmTasks('grunt-contrib-less');
	grunt.loadNpmTasks('grunt-contrib-concat');
	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-ftp-deploy');
	grunt.loadNpmTasks('grunt-git');
	grunt.loadNpmTasks('grunt-http');

	// Default task.
	grunt.registerTask('default', function() {
		grunt.log.write('\nPlease Specify a Function\neg: ');
		grunt.log.ok('grunt watch');
		grunt.log.subhead('watch');
		grunt.log.writeln('Sets the Watch Event to start watching LESS, CSS, and JS');
		grunt.log.writeln('files in the SRC Folder');
		grunt.log.subhead('checkJS');
		grunt.log.writeln('Runs jsHint on all JS files in the SRC Folder');
		grunt.log.subhead('buildJS');
		grunt.log.writeln('Lints and Minifies all JS files in the SRC folder.');
		grunt.log.writeln('Moves them to the INCLUDES Folder');
		grunt.log.subhead('checkCSS');
		grunt.log.writeln('Runs Lint on all CSS files in the SRC Folder');
		grunt.log.subhead('buildCSS');
		grunt.log.writeln('Lints and Minifies all CSS files in the SRC folder.');
		grunt.log.writeln('Moves them to the INCLUDES Folder');
		grunt.log.subhead('compileLess');
		grunt.log.writeln('Compiles, Lints all LESS files in the SRC');
		grunt.log.subhead('buildLess');
		grunt.log.writeln('Compiles, Lints and Minifies all LESS files in the SRC');
		grunt.log.writeln('folder.  Moves the Resulting CSS Files to the INCLUDES Folder');
		grunt.log.subhead('buildDist');
		grunt.log.writeln('Copy Files for Distribution Version of Site and Makes a Git');
		grunt.log.writeln('Commit of those Changes');
		grunt.log.subhead('deploy');
		grunt.log.writeln('Deploys All Files in the Dest Folder to the Live Environment');
		grunt.log.subhead('buildAndDeploy');
		grunt.log.writeln('Runs the Build and Deploy Tasks');
		grunt.log.subhead('reloadLive');
		grunt.log.writeln('Sends site reload script');
	});
	grunt.registerTask('buildJS', ['jshint:build','uglify:build']);
	grunt.registerTask('checkJS', ['jshint:build']);
	grunt.registerTask('buildCSS', ['csslint:build','cssmin:build']);
	grunt.registerTask('checkCSS', ['csslint:build']);
	grunt.registerTask('compileLess', ['less:build','csslint:build']);
	grunt.registerTask('buildLess', ['less:build','csslint:build','cssmin:build']);
	grunt.registerTask('buildDist', ['copy:dist']);//,'gitcommit:dist']
	grunt.registerTask('deploy', ['ftp-deploy:deploy','http:reload']);
	grunt.registerTask('buildAndDeploy', ['copy:dist','ftp-deploy:deploy','http:reload']);//'gitcommit:dist',
	grunt.registerTask('reloadLive', ['http:reload']);

	grunt.event.on("watch", function(action, filepath, target) {
		var srcFolder = "src/";
		var destFolder = "includes/";
		grunt.log.writeln(target + ': ' + filepath + ' has ' + action);
		if (target == 'jsCompile') {
			grunt.config('jshint.file.src', filepath);
			grunt.config(['uglify', 'file', 'src'], filepath);
			grunt.config(['uglify', 'file', 'dest'], filepath.replace(srcFolder,destFolder).replace(/(\.js)$/gi,'.min.js'));
		} else if (target == 'cssCompile') {
			//grunt.config('csslint.file.src', filepath);
			grunt.config(['cssmin', 'file', 'src'], filepath);
			grunt.config(['cssmin', 'file', 'dest'], filepath.replace(srcFolder,destFolder).replace(/(\.css)$/gi,'.min.css'));
		} else if (target == 'lessCompile') {
			var cssFileName = filepath.replace("/less/","/css/").replace(/(\.less)$/gi,'.css');
			grunt.log.writeln('CSS File:' + cssFileName);
			grunt.config(['less', 'file', 'src'], srcFolder + "/less/bootstrap.less");
			grunt.config(['less', 'file', 'dest'], srcFolder + "/css/<%= pkg.name %>.css");
			//grunt.config('csslint.file.src', srcFolder + "/css/<%= pkg.name %>.css");
			grunt.config(['cssmin', 'file', 'src'], srcFolder + "/css/<%= pkg.name %>.css");
			grunt.config(['cssmin', 'file', 'dest'], destFolder + "/css/<%= pkg.name %>.min.css");
		} // close if target...
	}); // close grunt.event.on("watch")


}; // close module.exports
