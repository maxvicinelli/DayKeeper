import csv
import random as r
def calendar_tests_1(test_file):    
    with open(test_file, 'w', newline='') as csvfile:
        fieldnames = ['Type', 'Name', 'Date', 'Status']
        
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for i in range(100):
            #writer.writerow({'Type' : "Class", 'Name' : "History", 'Date' : "%d"%i, 'Status': r.choice(["Early","Late"]) })
            writer.writerow({'Type' : "Class", 'Name' : "History", 'Date' : "%d"%i, 'Status': r.choice([0,1]) })
               
def calendar_tests_2(test_file):    
    with open(test_file, 'w', newline='') as csvfile:
        fieldnames = ['Type', 'Name', 'Date', 'Status']
        
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for i in range(100):
            #writer.writerow({'Type' : "Class", 'Name' : "History", 'Date' : "%d"%i, 'Status': r.choice(["Early","Late"]) })
            x = semi_gauss_random()
            writer.writerow({'Type' : "Class", 'Name' : "History", 'Date' : "%d"%i, 'Status': x })

def semi_gauss_random():
    x = min(1, max(0, r.gauss(0.2, 0.5)))
    if (x>=0.5):
        return 1
    return 0          

def calendar_tests_3(test_file):    
    with open(test_file, 'w', newline='') as csvfile:
        fieldnames = ['Type', 'Name', 'Date', 'Status']
        
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for i in range(100):
            #writer.writerow({'Type' : "Class", 'Name' : "History", 'Date' : "%d"%i, 'Status': r.choice(["Early","Late"]) })
            is_late_or_early = semi_gauss_random()
            writer.writerow({'Type' : "Class", 'Name' : "History", 'Date' : "%d"%i, 'Status': is_late_or_early })
            if i>=50:
                is_late_or_early = semi_gauss_random()
                writer.writerow({'Type' : "Class", 'Name' : "English", 'Date' : "%d"%i, 'Status': is_late_or_early })
            if i%2:
                is_late_or_early = semi_gauss_random()
                writer.writerow({'Type' : "Sport", 'Name' : "Hockey", 'Date' : "%d"%i, 'Status': is_late_or_early })
                
def semi_gauss_random():
    x = min(1, max(0, r.gauss(0.2, 0.5)))
    if (x>=0.5):
        return 1
    return 0     



if __name__ == "__main__":
    # uniform randomness
    # calendar_tests_1('test1.csv')
    
    # normally distributed randomness
    # calendar_tests_2('test2.csv')
    
    # adding a similar event halfway through
    calendar_tests_3('test3.csv')
    