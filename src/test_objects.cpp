#include "test_objects.hpp"

house::house():redhand::Actor(){

    std::vector<glm::vec2> points_coordinates = {
        {1.0f, 0.55f},  // top right
        {1.0f, 0.0f},  // bottom right
        {0.0f, 0.0f},  // bottom left
        {0.0f, 0.55f},  // top left 
        {0.5f, 1.0f}  // top middle
    };

    std::vector<std::array<unsigned int, 3> > triangle_indices = {
        {0, 1, 3},   // first triangle
        {1, 2, 3},    // second triangle
        {0, 3, 4}     //third triangle
    };

    std::vector<glm::vec3> point_colors = {
        {1.0f, 1.0f, 1.0f},
        {1.0f, 1.0f, 1.0f},
        {1.0f, 1.0f, 1.0f},
        {1.0f, 1.0f, 1.0f},
        {1.0f, 1.0f, 1.0f} 
    };

    updateBufferData(points_coordinates,triangle_indices,point_colors);
    setImage("testgame/textures/open/crate.png");
    scaleActor(0.5);
    setPosition({-0.1f,-0.1f});

}

void house::act(redhand::game_loop_event){
    //move the house

    if( redhand::input_system::static_isKeyPressed(redhand::KEY_RIGHT) ){
        this->move({0.02f,0.0f});
    }else if(redhand::input_system::static_isKeyPressed(redhand::KEY_LEFT)){
        this->move({-0.02f,0.0f});
    }

    if(redhand::input_system::static_isKeyPressed(redhand::KEY_UP)){
        this->move({0.0f,0.02f});
    }else if(redhand::input_system::static_isKeyPressed(redhand::KEY_DOWN)){
        this->move({0.0f,-0.02f});
    } 

    //check for button presses and change rotation

    if(redhand::input_system::static_isKeyPressed(redhand::KEY_E)){
        this->turn(-2.5f);
    }else if(redhand::input_system::static_isKeyPressed(redhand::KEY_Q)){
        this->turn(2.5f);
    }

    return;

}


hand::hand(){

    setImage("logo/redhand.svg.png");
    setPosition( {-0.5f, +0.5f});
    scaleActor(0.5f);
    setColorAlpha(1.0f);
    setRotaionAxis({0.0f, 1.0f, 0.0f});

}

void hand::act(redhand::game_loop_event evt){
    //move the house
    auto delta = evt.getFrameTime().count();
    this->turn(static_cast<float>(delta) * 30.0f / 1000000000.0f );

    return;
}