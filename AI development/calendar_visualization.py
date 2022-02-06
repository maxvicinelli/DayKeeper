import datetime as dt
import matplotlib.pyplot as plt
import numpy as np
from AI_calendar import set_notification_schedule, set_notification_schedule_v2

def main():
    # call generate data with parameter of 1 for version 1 of notification schedule, 2 for version 2
    # Version 1: if the user has been late 3 times in the last 5 days, increment the notification schedule
    # if the user has been ontime 2 times in the last 2 days, decrement the notification schedule
    # Version 2, STRICTER VERSION: if the user has been late 2 times in the last 7 days, increment the notification schedule
    # if the user has been ontime for a 7 days straight, decrement the notification schedule

    # version = 1
    version = 2
    dates, data, statuses = generate_data(version)
    fig, ax = plt.subplots(figsize=(6, 10))
    calendar_heatmap(ax, dates, data)
    fig, ax = plt.subplots(figsize=(6, 10))
    calendar_heatmap(ax, dates, statuses)
    plt.show()

def generate_data(version):
    num = 100
    #data = np.random.randint(0, 20, num)
    if version == 1:
        data, statuses = set_notification_schedule('test1.csv')
    elif version == 2:
            data, statuses = set_notification_schedule_v2('test1.csv')
    print(data)
    start = dt.datetime(2015, 3, 13)
    dates = [start + dt.timedelta(days=i) for i in range(num)]
    return dates, data, statuses

def calendar_array(dates, data):
    i, j = zip(*[d.isocalendar()[1:] for d in dates])
    i = np.array(i) - min(i)
    j = np.array(j) - 1
    ni = max(i) + 1

    calendar = np.nan * np.zeros((ni, 7))
    calendar[i, j] = data
    return i, j, calendar


def calendar_heatmap(ax, dates, data):
    i, j, calendar = calendar_array(dates, data)
    im = ax.imshow(calendar, interpolation='none', cmap='summer')
    label_days(ax, dates, i, j, calendar)
    label_months(ax, dates, i, j, calendar)
    ax.figure.colorbar(im)

def label_days(ax, dates, i, j, calendar):
    ni, nj = calendar.shape
    day_of_month = np.nan * np.zeros((ni, 7))
    day_of_month[i, j] = [d.day for d in dates]

    for (i, j), day in np.ndenumerate(day_of_month):
        if np.isfinite(day):
            ax.text(j, i, int(day), ha='center', va='center')

    ax.set(xticks=np.arange(7), 
           xticklabels=['M', 'T', 'W', 'R', 'F', 'S', 'S'])
    ax.xaxis.tick_top()

def label_months(ax, dates, i, j, calendar):
    month_labels = np.array(['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                             'Aug', 'Sep', 'Oct', 'Nov', 'Dec'])
    months = np.array([d.month for d in dates])
    uniq_months = sorted(set(months))
    yticks = [i[months == m].mean() for m in uniq_months]
    labels = [month_labels[m - 1] for m in uniq_months]
    ax.set(yticks=yticks)
    ax.set_yticklabels(labels, rotation=90)

main()