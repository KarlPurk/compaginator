module.exports = function(grunt) {
    "use strict";

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
        }
    });

    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-copy');

    grunt.registerTask('default', ['build_tests', 'build']);
    grunt.registerTask('build', ['coffee:build', 'uglify', 'copy']);
    grunt.registerTask('build_tests', ['coffee:tests']);
};