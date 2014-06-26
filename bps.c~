#include<stdlib.h>
#include<stdio.h>
#include<string.h>

#define INPUT_MODE 1
#define ONE 1
#define ZERO 0
int num_list=0;
int rear=-1;
int front=-1;
int top=-1;
unsigned int mask;
////////////////////////////////////////////////////////////////////////////////////
struct ENTRY{
	unsigned int ip;
	unsigned char len;
	unsigned char port;
};
////////////////////////////////////////////////////////////////////////////////////
inline unsigned long long int rdtsc()
{
	unsigned long long int x;
	asm   volatile ("rdtsc" : "=A" (x));
	return x;
}
////////////////////////////////////////////////////////////////////////////////////
struct list{//structure of binary trie
	unsigned int port;
	//unsigned char ori_prefix;
	struct list *left,*right;
};
typedef struct list node;
typedef node *btrie;
////////////////////////////////////////////////////////////////////////////////////RECORD
typedef struct 						 
{
	unsigned int ip;
	unsigned int heigh;
}RECORD;
#define MAX_NUMBER 1000000
RECORD Final_List[MAX_NUMBER],apq_data[MAX_NUMBER],stack_data[MAX_NUMBER],temp_record,MP,mp_parent;

////////////////////////////////////////////////////////////////////////////////////
/*global variables*/
btrie root;
unsigned int *query;
int num_entry=0;
int num_query=0;
struct ENTRY *table;
int N=0;//number of nodes
unsigned long long int begin,end,total=0;
unsigned long long int *clock;
int num_node=0;//total number of nodes in the binary trie

////////////////////////////////////////////////////////////////////////////////////
btrie create_node(){
	btrie temp;
	num_node++;
	temp=(btrie)malloc(sizeof(node));
	temp->right=NULL;
	temp->left=NULL;
	temp->port=256;//default port
	return temp;
}
////////////////////////////////////////////////////////////////////////////////////
void add_node(unsigned int ip,unsigned char len,unsigned char nexthop){
	btrie ptr=root;
	int i;
	for(i=0;i<len;i++){
		if(ip&(1<<(31-i))){
			if(ptr->right==NULL)
				ptr->right=create_node(); // Create Node
			ptr=ptr->right;
			if((i==len-1)&&(ptr->port==256))
				ptr->port=nexthop;
		}
		else{
			if(ptr->left==NULL)
				ptr->left=create_node();
			ptr=ptr->left;
			if((i==len-1)&&(ptr->port==256))
				ptr->port=nexthop;
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////
void read_table(char *str,unsigned int *ip,int *len,unsigned int *nexthop){
	char tok[]="./";
	char buf[100],*str1;
	unsigned int n[4];
	sprintf(buf,"%s\0",strtok(str,tok));
	n[0]=atoi(buf);
	sprintf(buf,"%s\0",strtok(NULL,tok));
	n[1]=atoi(buf);
	sprintf(buf,"%s\0",strtok(NULL,tok));
	n[2]=atoi(buf);
	sprintf(buf,"%s\0",strtok(NULL,tok));
	n[3]=atoi(buf);
	*nexthop=n[2];
	str1=(char *)strtok(NULL,tok);
	if(str1!=NULL){
		sprintf(buf,"%s\0",str1);
		*len=atoi(buf);
	}
	else{
		if(n[1]==0&&n[2]==0&&n[3]==0)
			*len=8;
		else
			if(n[2]==0&&n[3]==0)
				*len=16;
			else
				if(n[3]==0)
					*len=24;
	}
	*ip=n[0];
	*ip<<=8;
	*ip+=n[1];
	*ip<<=8;
	*ip+=n[2];
	*ip<<=8;
	*ip+=n[3];
}
////////////////////////////////////////////////////////////////////////////////////search
void search(unsigned int ip){		
	int j;
	btrie current=root,temp=NULL;
	for(j=31;j>=(-1);j--){
		if(current==NULL)
			break;
		if(current->port!=256)
			temp=current;
		if(ip&(1<<j)){
			current=current->right;
		}
		else{
			current=current->left; 
		}
	}
	//if(temp==NULL)
	//printf("default\n");
	//else
	//printf("%u\n",temp->port);
}
////////////////////////////////////////////////////////////////////////////////////
void set_table(char *file_name){
	FILE *fp;
	int len;
	char string[100];
	unsigned int ip,nexthop;
	fp=fopen(file_name,"r");
	while(fgets(string,50,fp)!=NULL){
		read_table(string,&ip,&len,&nexthop);
		num_entry++;
	}
	rewind(fp);
	table=(struct ENTRY *)malloc(num_entry*sizeof(struct ENTRY));
	num_entry=0;
	while(fgets(string,50,fp)!=NULL){
		read_table(string,&ip,&len,&nexthop);
		table[num_entry].ip=ip;
		table[num_entry].port=nexthop;
		table[num_entry++].len=len;
	}
}
////////////////////////////////////////////////////////////////////////////////////
void set_query(char *file_name){
	FILE *fp;
	int len;
	char string[100];
	unsigned int ip,nexthop;
	fp=fopen(file_name,"r");
	while(fgets(string,50,fp)!=NULL){
		read_table(string,&ip,&len,&nexthop);
		num_query++;
	}
	//printf("num_query=%d(jungle)\n", num_query);	// add by jungle
	rewind(fp);
	query=(unsigned int *)malloc(num_query*sizeof(unsigned int));
	clock=(unsigned long long int *)malloc(num_query*sizeof(unsigned long long int));
	num_query=0;
	while(fgets(string,50,fp)!=NULL){
		read_table(string,&ip,&len,&nexthop);
		query[num_query]=ip;
		clock[num_query++]=10000000;
		//printf("ip=0x%08x\n", ip);	//add by jungle
	}
}
////////////////////////////////////////////////////////////////////////////////////
void create(){
	int i;
	root=create_node();
	begin=rdtsc();
	for(i=0;i<num_entry;i++)
		add_node(table[i].ip,table[i].len,table[i].port);
	end=rdtsc();
}
////////////////////////////////////////////////////////////////////////////////////
void count_node(btrie r){
	if(r==NULL)
		return;
	count_node(r->left);
	N++;
	count_node(r->right);
}
////////////////////////////////////////////////////////////////////////////////////
void CountClock()
{
	unsigned int i;
	unsigned int* NumCntClock = (unsigned int* )malloc(50 * sizeof(unsigned int ));
	for(i = 0; i < 50; i++) NumCntClock[i] = 0;
	unsigned long long MinClock = 10000000, MaxClock = 0;
	for(i = 0; i < num_query; i++)
	{
		if(clock[i] > MaxClock) MaxClock = clock[i];
		if(clock[i] < MinClock) MinClock = clock[i];
		if(clock[i] / 100 < 50) NumCntClock[clock[i] / 100]++;
		else NumCntClock[49]++;
	}
	printf("(MaxClock, MinClock) = (%5llu, %5llu)\n", MaxClock, MinClock);
	
	/*for(i = 0; i < 50; i++)
	{
		printf("%d : %d\n", (i + 1) * 100, NumCntClock[i]);
	}*/
	return;
}

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////
int main(int argc,char *argv[]){
	int i,j;
	int k=0;
#ifdef INPUT_MODE

	if(argc != 2){
		printf("Please execute the file as the following way:\n");
		printf("%s  routing_table_file_name \n",argv[0]);
		exit(1);
	}
	set_query(argv[1]);
	set_table(argv[1]);
#else
	set_query("IPv4-Prefix-AS6447-2012-02-07-1-407218.txt");
	set_table("IPv4-Prefix-AS6447-2012-02-07-1-407218.txt");
#endif
	create();
inorder_traversal_build_list(root);
for(k=0; k<num_list; k++){
printf("after leaf pushing and merge, node is prefix:0x%08x\n", Final_List[k].ip);
}
conversion();
for(k=0; k<num_list; k++){
printf("after conversion, node is prefix:0x%08x\n", Final_List[k].ip);
}
	printf("Avg. Inseart: %llu\n",(end-begin)/num_entry);
	printf("number of nodes: %d\n",num_node);
	printf("Total memory requirement: %d KB\n",((num_node*12)/1024));


////////////////////////////////////////////////////////////////////////////

	for(j=0;j<100;j++){
		for(i=0;i<num_query;i++){
			begin=rdtsc();
			search(Final_List[i].ip);
			end=rdtsc();
			if(clock[i]>(end-begin))
				clock[i]=(end-begin);
		}
	}
	total=0;
	for(j=0;j<num_query;j++)
		total+=clock[j];
	printf("Avg. Search: %llu\n",total/num_query);
	
	CountClock();
////////////////////////////////////////////////////////////////////////////
	count_node(root);
	printf("There are %d nodes in binary trie\n",N);
	return 0;
}

////////////////////////////////////////////////////////////////////////////////////addlist:put the result to final_list
void addlist(RECORD item)			
{
	Final_List[num_list].ip=item.ip;
	Final_List[num_list].heigh=item.heigh;
	num_list++;
}
////////////////////////////////////////////////////////////////////////////////////APQueue

void resetAPQ()						//resetAPQ
{
	rear=front=-1;
}

void addAPQ(RECORD item)            			//addAPQ
{
	rear++;
	apq_data[rear].ip = item.ip;
	apq_data[rear].heigh = item.heigh;
}
////////////////////////////////////////////////////////////////////////////////////STACK

void popstack()						//popstack
{
	top--;
}

void pushstack(RECORD item)				//pushstack
{
	top++;
	stack_data[top].ip=item.ip;
	stack_data[top].heigh=item.heigh;
}
////////////////////////////////////////////////////////////////////////////////merge
void merge()						
{
	int i=0;
	int ready_to_add=0;
	int common_bit=0;
	unsigned int temp, temp2;
	unsigned int mask_mer=0;
	switch(rear){
		case 0:
			for(i=0; i<(apq_data[rear].heigh-1); i++){
				mask_mer |= (ONE<<(32-i-1));
			}
			mp_parent.ip = (apq_data[rear].ip & mask_mer);
			mp_parent.heigh = apq_data[rear].heigh-1;
 			for(i=0; i<num_list; i++){
				if((Final_List[i].ip == mp_parent.ip)&&(Final_List[i].heigh == mp_parent.heigh)){
					ready_to_add=1;
					break;
				}
			}
			if(ready_to_add == 0){
				addlist(apq_data[rear]);
				//printf("add_merge: 0x%08x\n",Final_List[num_list-1].ip);
				resetAPQ();
				//printf("resetAPQ\n");
				break;
			}
			else
				break;
				
		case 1:
			for(i=32; i>0; i--){
				temp=apq_data[rear-1].ip & (ONE<<(i-1));
				temp2=apq_data[rear].ip & (ONE<<(i-1));
				if(temp == temp2){
					common_bit++;
				}
				else
					break;
			}
			//printf("common_bit:%d\n",common_bit);
			for(i=0; i<common_bit; i++){
				mask_mer |= (ONE<<(32-i-1));
			}
			MP.ip = apq_data[rear].ip & mask_mer;
			MP.heigh = common_bit;
			mask_mer <<= 1;
			mp_parent.ip = apq_data[rear].ip & mask_mer;
			mp_parent.heigh = common_bit-1;
			//printf("mp_parent.ip: 0x%08x\n",mp_parent.ip);
			//printf("mp_parent.heigh:%d\n",mp_parent.heigh);
			for(i=0; i<num_list; i++){
				if((Final_List[i].ip == mp_parent.ip)&&(Final_List[i].heigh == mp_parent.heigh)){
						ready_to_add=1;
						break;
				}
			}
			for(i=0; i<num_list; i++){
				printf("this node is prefix:0x%08x\n", Final_List[i].ip);
			}
			//printf("ready_to_add:%d\n",ready_to_add);
			if(ready_to_add == 0){
				addlist(MP);
				//printf("add_merge: 0x%08x\n",Final_List[num_list-1].ip);
				resetAPQ();
				//printf("resetAPQ\n");
				break;
			}
			else
				break;
				
		default:
			break;
	}
}	

void merge2()						
{
	int i=0;
	int ready_to_add=0;
	int common_bit=0;
	unsigned int temp, temp2, mp_parent;
	unsigned int mask_mer=0;
	switch(rear){
		case 0:
				addlist(apq_data[rear]);
				//printf("add_merge: 0x%08x\n",Final_List[num_list-1].ip);
				resetAPQ();
				//printf("resetAPQ\n");
			break;
				
		case 1:
			for(i=32; i>0; i--){
				temp=apq_data[rear-1].ip & (ONE<<(i-1));
				temp2=apq_data[rear].ip & (ONE<<(i-1));
				if(temp == temp2){
					common_bit++;
				}
				else
					break;
			}
			for(i=0; i<common_bit; i++){
				mask_mer |= (ONE<<(32-i-1));
			}
			MP.ip = apq_data[rear].ip & mask_mer;
			
				addlist(MP);
				//printf("add_merge: 0x%08x\n",Final_List[num_list-1].ip);
				resetAPQ();
				//printf("resetAPQ\n");


			break;
				
		default:
			break;
	}
}			
////////////////////////////////////////////////////////////////////////////////inorder_traversal
void inorder_traversal_build_list(btrie current)
{	
	if(current->port != 256){
		if(rear != -1){
			merge();	
		}
		if(current->left == NULL && current->right == NULL){
			addlist(temp_record);
			//printf("ADDlist: 0x%08x\n",Final_List[num_list-1].ip);
			resetAPQ();
			//printf("resetAPQ\n");
		}
		pushstack(temp_record);
		//printf("PUSH: 0x%08x\n",stack_data[top].ip);
	}
////////////////////////////////////////////////////////////////////////////////
	if(current->left != NULL){
		mask |= (ONE<<(32-temp_record.heigh-1));
		temp_record.ip |= (ZERO<<(32-temp_record.heigh-1));
		temp_record.heigh++;
//printf("node:0x%08x , heigh:%d\n",temp_record.ip ,temp_record.heigh);
		inorder_traversal_build_list(current->left);
		temp_record.heigh--;
		mask <<= 1;
		temp_record.ip &= mask;
//printf("node:0x%08x , heigh:%d\n",temp_record.ip ,temp_record.heigh);
	}
	else{
		if((top != -1) && (current->port == 256)){
			mask |= (ONE<<(32-temp_record.heigh-1));
			temp_record.ip |= (ZERO<<(32-temp_record.heigh-1));
			temp_record.heigh++;
			addAPQ(temp_record);
			//printf("ADDQ: 0x%08x\n",apq_data[rear].ip);
			temp_record.heigh--;
			mask <<= 1;
			temp_record.ip &= mask;
		}
	}
////////////////////////////////////////////////////////////////////////////////
	if(current->port != 256){
		if(rear != -1){
			merge();
		}
		//printf("Final_List[num_list-1].ip: 0x%08x\n",Final_List[num_list-1].ip);
		//printf("Final_List[num_list-1].heigh: %d\n",Final_List[num_list-1].heigh);
		//printf("temp_record.heigh: %d\n",temp_record.heigh);
		//printf("temp_record.ip: 0x%08x\n",temp_record.ip);
		if((Final_List[num_list-1].ip == temp_record.ip)&&(Final_List[num_list-1].heigh == temp_record.heigh)){
			//printf("This node is same as last , no add\n");
		}	
		else{
			addlist(temp_record);
			//printf("ADDlist: 0x%08x\n",Final_List[num_list-1].ip);
		}
	}
////////////////////////////////////////////////////////////////////////////////
	if(current->right != NULL){
		mask |= (ONE<<(32-temp_record.heigh-1));
		temp_record.ip |= (ONE<<(32-temp_record.heigh-1));
		temp_record.heigh++;
//printf("node:0x%08x , heigh:%d\n",temp_record.ip ,temp_record.heigh);
		inorder_traversal_build_list(current->right);
		temp_record.heigh--;
		mask <<= 1;
		temp_record.ip &= mask;
//printf("node:0x%08x , heigh:%d\n",temp_record.ip ,temp_record.heigh);
	}
	else{
		if((top != -1) && (current->port == 256)){
			mask |= (ONE<<(32-temp_record.heigh-1));
			temp_record.ip |= (ONE<<(32-temp_record.heigh-1));
			temp_record.heigh++;
			addAPQ(temp_record);
			//printf("ADDQ: 0x%08x\n",apq_data[rear].ip);
			temp_record.heigh--;
			mask <<= 1;
			temp_record.ip &= mask;
		}
	}
////////////////////////////////////////////////////////////////////////////////
	if(current->port != 256){
		
		popstack();
		//printf("POP\n");
		
		if(rear != -1){
			merge2();	
		}
	}
}
////////////////////////////////////////////////////////////////////////////////conversion:32bit prefix convert to 32bit prefix
void conversion()
{
	int i;
	unsigned int temp;
	for(i=0; i<num_list; i++){
		if(Final_List[i].heigh < 32){
			Final_List[i].ip |= (ONE<<32-Final_List[i].heigh-1);
		}
	}
	for(i=0; i<num_list; i++){
		if(Final_List[i].heigh == 32){
			temp = (Final_List[i].ip & ONE);
			if(temp == 0){
				Final_List[i].ip |= ONE;
				Final_List[i+1].ip &= ZERO;
			}
			else{
				Final_List[i].ip &= ZERO;
			}
		}
	}   					
}






