# Ariel Attias
# Feb 2, 2022


# testing AI

# input:
# calendar and outcome (late/early)

# output:
# which notification scheme was utilized

# tests are intended to flesh out which method of increasing or decreasing notification count should be used
# for now notification scheme will just be numbered by severity (1 through 4).

import csv
import random as r
import pandas as pd 

def calendar_tests_1(test_file):    
    with open(test_file, 'w', newline='') as csvfile:
        fieldnames = ['Type', 'Name', 'Date', 'Status']
        
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for i in range(100):
            writer.writerow({'Type' : "Class", 'Name' : "History", 'Date' : "%d"%i, 'Status': r.choice(["0","1"]) })


def set_notification_schedule(test_file, window, late_threshold, early_threshold): 
    # event: list of statuses
    events = {}
    # event: list of notification level for each day
    schedule_list= {}
    
    with open(test_file, 'r', newline='') as csvfile:
        csv_reader = csv.reader(csvfile, delimiter=',')
        # skip 
        next(csv_reader)
        for row in csv_reader:
            #fieldnames = ['Type', 'Name', 'Date', 'Status']
            
            # guard clause in case event not created
            if row[1] not in events:
                  events[row[1]]=[-1]
                  schedule_list[row[1]]=[0]

            events[row[1]].append(int(row[3]))

            # if the user has been late 3 times in the last "window" days, increment the notification schedule
        

            if sum(events[row[1]][-window:]) >= late_threshold:
                schedule_list[row[1]] += [min(4, 1+ schedule_list[row[1]][-1])]
            # if the user has been ontime 2 times in the last 2 days, decrement the notification schedule
            elif events[row[1]][-2:] == [0] * early_threshold:
                schedule_list[row[1]] += [max(0, schedule_list[row[1]][-1] - 1)]
            else:
                schedule_list[row[1]] += [schedule_list[row[1]][-1]]
    #print(len(schedule_list[row[1]]))
    return schedule_list[row[1]][1:],events[row[1]][1:]
            
            
def set_notification_schedule_test_3(test_file, window, late_threshold, early_threshold): 
    # event: list of statuses
    events = {}
    # event: list of notification level for each day
    schedule_list= {}
    # store event types
    event_types = {}
    
    with open(test_file, 'r', newline='') as csvfile:
        csv_reader = csv.reader(csvfile, delimiter=',')
        # skip 
        next(csv_reader)
        for row in csv_reader:
            #fieldnames = ['Type', 'Name', 'Date', 'Status']
            
            # guard clause in case event not created
            if row[1] not in events:
                events[row[1]]=[-1]
                schedule_list[row[1]]=[0]
                
                # new logic for test case 3
                # if we are already keeping track of an event of the same type, set the notification schedule to it.
                if row[0] in event_types:
                    similar_events = [k for k,v in event_types.items() if v == row[0]]
                    average_score = 0
                    for event in similar_events:
                        average_score += schedule_list[event][-1]
                    schedule_list[row[1]] = [average_score/len(similar_events)]
                    
                    
                event_types[row[1]] = [row[0]]

            events[row[1]].append(int(row[3]))

            # if the user has been late 3 times in the last "window" days, increment the notification schedule

            if sum(events[row[1]][-window:]) >= late_threshold:
                schedule_list[row[1]] += [min(4, 1+ schedule_list[row[1]][-1])]
            # if the user has been ontime 2 times in the last 2 days, decrement the notification schedule
            elif events[row[1]][-2:] == [0] * early_threshold:
                schedule_list[row[1]] += [max(0, schedule_list[row[1]][-1] - 1)]
            else:
                schedule_list[row[1]] += [schedule_list[row[1]][-1]]
    #print(len(schedule_list[row[1]]))
    return schedule_list,events

if __name__ == "__main__":
    #calendar_tests_1('test1.csv')
    window, late_threshold, early_threshold = 5, 3, 2
    #print(set_notification_schedule('test1.csv', window, late_threshold, early_threshold))
    print(set_notification_schedule_test_3('test3.csv', window, late_threshold, early_threshold))