'''
Helpers for exploritory data analysis
'''


def compare(df, cols, kind='hist', n_cols=2, n_rows=1,
            figsize=(16, 5), title=''):
    '''
    Quickly compare two columns from a dataframe.
    '''
    df[cols].plot(
        kind='hist', title=title,
        subplots=True, sharex=True, sharey=True,
        layout=(n_cols, n_rows), figsize=figsize)
