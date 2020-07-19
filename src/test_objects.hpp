#pragma once

#include "redhand/all.hpp"

class house : public redhand::Actor{
    public:
        house();

        void act(redhand::game_loop_event evt);
};

class hand : public redhand::Actor{
    public:
        hand();

        void act(redhand::game_loop_event evt);

};