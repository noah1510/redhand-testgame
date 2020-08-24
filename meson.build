project(
    'redhand-testgame',
    'cpp',
    default_options : [
        'c_std=c11', 
        'cpp_std=c++17'
    ],
    version: '0.1.2'
)

dep = [dependency('redhand', required : true, fallback : ['redhand', 'redhand_dep'])]

incdir = include_directories('src')

sources = [ 
    'src/game.cpp', 
    'src/test_objects.cpp', 
    'src/test_world.cpp', 
    'src/main.cpp'
]

executable(
    'redhand-testgame', 
    sources,
    include_directories : incdir,
    dependencies: dep
)

