# social_interaction_network_virus_model
simulate the spread of a virus through social contacts modeled on a real social network

![alt text](https://user-images.githubusercontent.com/34073563/85622373-c5b8d200-b634-11ea-9f35-f20cf7930bac.png)

This simulation package is intended as a tool for experimenting with different models of social contact and social distancing as a virus spreads through a population. The virus model we use is basically an SIR model that updates daily based on simulated daily contacts between individuals. The properties of our virus model were parameterized to roughly approximate the behavior or the novel coronavirus SARS-CoV-2 as per what has been observed so far in the literature.

We used real social network data taken from a US college in 2005 to build a model of social interaction that mimicks daily life on a college campus, with weekends being more social and friend groups, housing assignment, and classyear driving the underlying probabilities of individuals interacting. The groups of close friends (there are 659) were determined using a new method of community detection we call Automated Quasi-clique Merger (AQCM) (publication in preparation, and some mathematical support currently under review for publication). The college network has 3826 individuals. 
