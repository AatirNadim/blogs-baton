#include <stdio.h>
#include <stdlib.h>

struct Node {
    int data;
    struct Node* next;
};

int main() {
    struct Node* head = NULL;
    struct Node* second = NULL;
    struct Node* third = NULL;

    head = (struct Node*)malloc(sizeof(struct Node));
    second = (struct Node*)malloc(sizeof(struct Node));
    third = (struct Node*)malloc(sizeof(struct Node));

    head->data = 1;
    head->next = second;
    second->data = 2;
    second->next = third;
    third->data = 3;
    third->next = NULL;

    printf("Walking through the linked list:\n");
    struct Node* current = head;
    while(current != NULL) {
        printf("%d -> ", current->data);
        current = current->next;
    }

    printf("NULL\n");


    /**
     * This is the important section of the code where we release the memory allocated for the linked list.
     * It is crucial to free each node to prevent memory leaks.
     * The code iterates through the linked list, freeing each node one by one.
     */

    printf("Releasing memory...\n");
    current = head;
    struct Node* nextNode;
    while(current != NULL) {
        nextNode = current->next;
        free(current);
        current = nextNode;
    }
    printf("Memory released successfully.\n");
    return 0;
}
