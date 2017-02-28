# Goal

Write a program that generates music which satisfy the rules of classical music theory.

Right now, I have hard-coded rules which determine what chord-transitions are acceptable and what probability they will be taken with, and then the program takes a random walk within those transitions. Then once a chord has been chosen (based on the previous one), it chooses an inversion which avoids parallel fifth motion and parallel octave motion.

# Todo

First, I would like to improve the static model for generating music. I would like to stratify the voices more, perhaps even using different instruments for different voices. I would like the voices to prefer pitch continuity instead of jumping around on the scale.

Then, I would like to add rhythmic motion to the static model. I am not sure how I would do this.

Finally, I want to replace the static model with a learned-model. Once I have all of these features of music (chord progression, parallel motion detection, pitch continuity), instead of hard-coding rules, I want to learn the frequency and occurence patterns in real music. Then I could generate music without having to write arbitrary rules. I do not see myself using an ANN at first, because I think I can get decent results with a Markov chain, and a simpler solution that does almost as well is better than a complex solution.

# Other projects like this

- See [this](https://en.wikipedia.org/wiki/Emily_Howell)
- See [this](https://magenta.tensorflow.org/2016/07/15/lookback-rnn-attention-rnn/)
- See [this](https://en.wikipedia.org/wiki/Long_short-term_memory)
