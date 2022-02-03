import csv
import random as r
def calendar_tests_1(test_file):    
    with open(test_file, 'w', newline='') as csvfile:
        fieldnames = ['Type', 'Name', 'Date', 'Status']
        
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for i in range(100):
            writer.writerow({'Type' : "Class", 'Name' : "History", 'Date' : "%d"%i, 'Status': r.choice(["Early","Late"]) })
                    
               
if __name__ == "__main__":
    calendar_tests_1('test1.csv')