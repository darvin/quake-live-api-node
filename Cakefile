path = require 'path'
fs = require 'fs'
wrench = require 'wrench'
{spawn, exec} = require 'child_process'


task 'build', 'Compile CoffeeScript source to Javascript', ->
    invoke 'clean'
    options = ['-c', '-o', 'lib', 'src']

    coffee = spawn 'coffee', options
    coffee.stdout.on 'data', (data) -> print data.toString()
    coffee.stderr.on 'data', (data) -> print data.toString()
    coffee.on 'exit', (status) -> callback?() if status is 0
      
        
    
task 'clean', 'Clean build matter', ->
    wrench.rmdirSyncRecursive('lib',true)
    wrench.rmdirSyncRecursive('-p',true)
    