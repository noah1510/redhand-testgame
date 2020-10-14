project(
    'redhand-testgame',
    'cpp',
    default_options : [
        'c_std=c11', 
        'cpp_std=c++17'
    ],
    version: '0.1.2'
)

testgame_incdir = include_directories('src')

testgame_sources = [ 
    files('src/game.cpp'), 
    files('src/test_objects.cpp'), 
    files('src/test_world.cpp'), 
    files('src/main.cpp')
]

if not meson.is_subproject()
    dep = [dependency('redhand', required : true, fallback : ['redhand', 'redhand_dep'])]
    
    executable(
        'redhand-testgame', 
        testgame_sources,
        include_directories : testgame_incdir,
        dependencies: dep
    )    
endif




