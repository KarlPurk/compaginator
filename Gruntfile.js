module.exports = function(grunt) {
    "use strict";

    var compaginatorBanner = '/* Compaginator v' + grunt.file.readJSON('package.json').version + ' */';

    grunt.initConfig({

        pkg: grunt.file.readJSON('package.json'),

        coffee: {
            build: {
                files: {
                    'dist/compaginator.js': ['lib/*.coffee']
                }
            },
            tests: {
                options: {
                    bare: true
                },
                files: {
                    'spec/integration.spec.js': ['tests/integration/*.coffee'],
                    'spec/unit.spec.js': ['tests/unit/*.coffee']
                }
            }
        },

        uglify: {
            dist: {
                files: {
                    'dist/compaginator.min.js': ['dist/compaginator.js']
                }
            }
        },

        copy: {
            examples: {
                files: [
                    {expand: true, flatten: true, src: ['dist/compaginator.min.js'], dest: 'examples/jquery/lib'}
                ]
            }
        },

        concat: {
            dev: {
                options: { banner: compaginatorBanner + "\r\n" },
                src: 'dist/compaginator.js',
                dest: 'dist/compaginator.js'
            },
            prod: {
                options: { banner: compaginatorBanner },
                src: 'dist/compaginator.min.js',
                dest: 'dist/compaginator.min.js'
            }
        },

        jasmine: {
            src: 'dist/compaginator.js',
            options: {
                specs: 'spec/*spec.js'
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-jasmine');

    grunt.registerTask('default', ['build_tests', 'build']);
    grunt.registerTask('build', ['coffee:build', 'uglify', 'concat', 'copy']);
    grunt.registerTask('build_tests', ['coffee:tests']);
    grunt.registerTask('test', ['jasmine'])
};