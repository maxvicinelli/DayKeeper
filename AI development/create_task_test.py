import csv
import random as r

def calendar_tests_4(test_file, event_tasks_file):    
    with open(test_file, 'w', newline='') as csvfile:
        fieldnames = ['Type', 'Name', 'Date', 'Order',  'Status']
        
        
        all_activities = {}
        all_activities["Class"] = ["Math", "History","English"]
        all_activities["Clubs"] = ["Soccer", "Model UN"]
        all_activities["Work"] = ["TAing", "Studying"]
        
        
        
        
        
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for i in range(50):
            #choose randome element from each class
            day_activities = []
            day_activities += [["Class", r.choice( all_activities["Class"])],
                               ["Clubs", r.choice( all_activities["Clubs"])],  
                               ["Work", r.choice( all_activities["Work"])]]
            
            r.shuffle(day_activities)
            order = 0
            for activity in day_activities:
                #writer.writerow({'Type' : "Class", 'Name' : "History", 'Date' : "%d"%i, 'Status': r.choice(["Early","Late"]) })
                writer.writerow({'Type' : activity[0], 'Name' : activity[1], 'Date' : "%d"%i,  'Order' :"%d"%order , 'Status': r.choice([0,1]) })
                order += 1
                
    with open(event_tasks_file, 'w', newline='') as csvfile:
        fieldnames = [ 'Name', 'Tasks']
        
        
          
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames, extrasaction='ignore')

        writer.writeheader()
        
        writer.writerow({'Name' : "Math" , "Tasks": ["pack bag", "bring calculator", "complete pre class question"] })
        writer.writerow({'Name' : "History" , "Tasks": ["pack bag", "bring textbook", "complete pre class question"] })
        writer.writerow({'Name' : "English" , "Tasks": ["pack bag", "bring textbook", "read poetry"] })
        writer.writerow({'Name' : "Soccer" , "Tasks": ["pack bag", "bring cleats"]})
        writer.writerow({'Name' : "Model UN" , "Tasks":["pack bag", "bring binder"] })
        writer.writerow({'Name' : "TAing" , "Tasks": ["pack bag", "bring notes"] })
        writer.writerow({'Name' : "Studying" , "Tasks": ["pack bag", "silence phone"] })

if __name__ == "__main__":
    # uniform randomness
    # calendar_tests_1('test1.csv')
    
    # normally distributed randomness
    # calendar_tests_2('test2.csv')
    
    # adding a similar event halfway through
    calendar_tests_4('test4.csv', 'test4_2.csv')
    