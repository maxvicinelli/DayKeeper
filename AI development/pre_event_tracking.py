# Ariel Attias
# Logic tying tasks to events
import csv
import random as r
import pandas as pd 
import ast
# List of tasks:
# Showering
# Brushing teeth
# putting clothes out
# preparing things/bag
# eating breakfast
# cleaning room 
# leaving early (does maps do this for us), will be variable based on how late you are




# add your own tasks tied to events

# infer from events with similar class

# add events based on time


def set_event_tasks(test_file, test_events_file): 
    # event: list of statuses
    events = {}
    # event: list of notification level for each day
    class_tasks = {}
    
    with open(test_events_file, 'r', newline='') as csvfile:
        csv_reader = csv.reader(csvfile, delimiter=',')
        # skip 
        next(csv_reader)
        for row in csv_reader:
            events[row[0]] = ast.literal_eval(row[1])
    print(events)
    
    
    with open(test_file, 'r', newline='') as csvfile:
        csv_reader = csv.reader(csvfile, delimiter=',')
        # skip 
        next(csv_reader)
        for row in csv_reader:
            #fieldnames = Type,Name,Date,Order,Status
           
            if row[3] == "0":
                print("Day %s"%row[2])
                print("Wakeup Tasks: Brush teeth, comb hair, eat breakfast, get dressed")
            tasks_string = ", ".join(events[row[1]])
            print("Event Tasks: " + tasks_string)
            print("Event: " +row[1])
             
            # guard clause in case event not created
            #if row[1] not in events:
                 
if __name__ == "__main__":

    print(set_event_tasks('test4.csv','test4_2.csv',))
    