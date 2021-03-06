from granatum_sdk import Granatum
import pandas as pd
from rpy2.robjects import r, IntVector, StrVector, DataFrame, Matrix, conversion, numpy2ri, pandas2ri

pandas2ri.activate()

def parse(st):
    return list(map(lambda s: s.strip(), list(filter(lambda s: s != "", st.split(',')))))

def main():
    gn = Granatum()
    assay_df = gn.pandas_from_assay(gn.get_import('assay'))
    grdict = gn.get_import('groupVec')
    phe_dict = pd.Series(gn.get_import('groupVec'))
    groups = set(parse(gn.get_arg('groups')))

    inv_map = {}
    for k, v in grdict.items():
        if v in groups:
            inv_map[v] = inv_map.get(v, []) + [k]
    cells = []
    for k, v in inv_map.items():
        cells.extend(v)
    assay_df = assay_df.loc[:, cells]
    assay_df = assay_df.sparse.to_dense().fillna(0)
    #assay_mat = r['as.matrix'](pandas2ri.py2ri(assay_df))
    # assay_mat = r['as.matrix'](conversion.py2rpy(assay_df))
    phe_vec = phe_dict[assay_df.columns]

    r.source('./drive_DESeq2.R')
    ret_r = r['run_DESeq'](assay_df, phe_vec)
    ret_r_as_df = r['as.data.frame'](ret_r)

    # ret_py_df = pandas2ri.ri2py(ret_r_as_df)
    # TODO: maybe rename the columns to be more self-explanatory?
    result_df = ret_r_as_df
    result_df = result_df.sort_values('padj')
    result_df.index.name = 'gene'
    gn.add_pandas_df(result_df.reset_index(), description='The result table as returned by DESeq2.')
    gn.export(result_df.to_csv(), 'DESeq2_results.csv', raw=True)
    significant_genes = result_df.loc[result_df['padj'] < 0.05]['log2FoldChange'].to_dict()
    gn.export(significant_genes, 'Significant genes', kind='geneMeta')
    gn.commit()


if __name__ == '__main__':
    main()
