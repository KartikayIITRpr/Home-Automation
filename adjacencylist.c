#include<stdio.h>
#include<stdlib.h>

struct adj_list_node{  // a node of the adjacency list
    int d ;
    struct adj_list_node *link ;
} ;

struct adj_list{  // array of all adjacency lists
    struct adj_list_node *head ;
} ;

struct graph{  // this will represent the graph, a graph is an array of adjacency list
    int v ;
    struct adj_list *f ;
} ;

struct adj_list_node *get_adj_list_node(int d){
    struct adj_list_node *newnode = (struct adj_list_node *)malloc(sizeof(struct adj_list_node)) ;
    newnode->d = d ;
    newnode->link = NULL ;
    return newnode ;
}

//this function creates a graph of V vertices
struct graph *create_graph(int v){
    struct graph *new_graph = (struct graph *)malloc(sizeof(struct graph)) ;
    new_graph->v = v ;
    int i ;
    for(i = 0; i < v ; i++){
        new_graph->f[i].head = NULL ;  //for every vertex we have created an adjacency list
    }
    return new_graph ; ;
}

void edge_add(struct graph *yo, int s, int d){    //this function will add an edge to our graph
    //we added a node from source to destination, source ki adjacency list mein
    struct adj_list_node *new_node = get_adj_list_node(d) ;
    new_node->link = yo->f[s].head ;
    yo->f[s].head = new_node->link ;

    //add a node from destination to source, destination ki adjacency list mein
    struct adj_list_node *new_node_yo = get_adj_list_node(s) ;
    new_node_yo->link = yo->f[d].head ;
    yo->f[d].head = new_node_yo->link ;                                                  
}

void graph_print(struct graph *temp){
    int i ;
    for(i = 0 ; i < temp->v ; i++){
        struct adj_list_node *a = temp->f[i].head ;
        printf("\n Adjacency list of vertex %d\n head ", i);
        while(a){
            printf("->%d" , a->d) ;
            a= a->link ;
        }
        printf("\n") ;
    }
}

int main(){
    int v = 5 ;
    struct graph *nish = create_graph(5) ;
    edge_add(nish, 0 , 1) ; 
    edge_add(nish, 0 , 4) ;
    edge_add(nish, 1 , 4) ;
    edge_add(nish, 1 , 3) ;
    edge_add(nish, 1 , 2) ;
    edge_add(nish, 3 , 2) ;
    edge_add(nish, 3 , 4) ;

    graph_print(nish) ;
    return 0 ;
}