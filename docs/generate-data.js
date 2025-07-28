// 数据生成脚本 - 将CSV数据转换为JSON格式
// 这个脚本用于处理df_browse.csv和codebook.csv文件

const fs = require('fs');
const path = require('path');

// 读取CSV文件的函数
function readCSV(filePath) {
    try {
        const content = fs.readFileSync(filePath, 'utf-8');
        const lines = content.split('\n').filter(line => line.trim());
        const headers = lines[0].split(',').map(h => h.replace(/"/g, '').trim());
        
        return lines.slice(1).map(line => {
            const values = parseCSVLine(line);
            const obj = {};
            headers.forEach((header, index) => {
                obj[header] = values[index] || '';
            });
            return obj;
        });
    } catch (error) {
        console.error(`读取文件失败: ${filePath}`, error);
        return [];
    }
}

// 解析CSV行（处理引号内的逗号）
function parseCSVLine(line) {
    const result = [];
    let current = '';
    let inQuotes = false;
    
    for (let i = 0; i < line.length; i++) {
        const char = line[i];
        
        if (char === '"') {
            inQuotes = !inQuotes;
        } else if (char === ',' && !inQuotes) {
            result.push(current.trim());
            current = '';
        } else {
            current += char;
        }
    }
    
    result.push(current.trim());
    return result;
}

// 变量分类映射
const categoryMapping = {
    // 基本信息
    'SearchTime': 'basic',
    'A2': 'basic',
    'A4': 'basic',
    'A5': 'basic',
    'A6': 'basic',
    'A7': 'basic',
    'A8': 'basic',
    
    // 健康状况
    'B1': 'health',
    'B2': 'health',
    'B3': 'health',
    'B4': 'health',
    'B5': 'health',
    'B6': 'health',
    'B7': 'health',
    'B8': 'health',
    'B9': 'health',
    'B10': 'health',
    
    // 生活方式
    'C1': 'lifestyle',
    'C2': 'lifestyle',
    'C3': 'lifestyle',
    'C4': 'lifestyle',
    'C5': 'lifestyle',
    'C6': 'lifestyle',
    'C7': 'lifestyle',
    'C8': 'lifestyle',
    'C9': 'lifestyle',
    'C10': 'lifestyle',
    
    // 医学检查
    'WBC': 'medical',
    'NEUT2': 'medical',
    'LYMPH2': 'medical',
    'MONO2': 'medical',
    'EOS2': 'medical',
    'BASO2': 'medical',
    'NEUT': 'medical',
    'LYMPH': 'medical',
    'MONO': 'medical',
    'EOS': 'medical',
    'BASO': 'medical',
    'RBC': 'medical',
    'HGB': 'medical',
    'HCT': 'medical',
    'MCV': 'medical',
    'MCH': 'medical',
    'MCHC': 'medical',
    'PLT': 'medical',
    'MPV': 'medical',
    'ALT': 'medical',
    'TP': 'medical',
    'ALB': 'medical',
    'CR': 'medical',
    'BUN': 'medical',
    'HCY': 'medical',
    'GLU': 'medical',
    'Ca': 'medical',
    'P': 'medical',
    'hs_CRP': 'medical',
    'TC': 'medical',
    'TG': 'medical',
    'HDL_C': 'medical',
    'LDL_C': 'medical',
    'Lp_a': 'medical',
    'UALB': 'medical',
    'UCr': 'medical',
    'T': 'medical',
    'INS': 'medical',
    'TG_Ab': 'medical',
    'TPO_Ab': 'medical',
    'FT3': 'medical',
    'FT4': 'medical',
    'TSH': 'medical',
    'HbA1b': 'medical',
    'GHB': 'medical',
    'HbA1c': 'medical',
    'MBG': 'medical',
    'GDX1': 'medical',
    'GDX2': 'medical',
    'GDX3': 'medical',
    'GDX4': 'medical',
    'YS_FA': 'medical',
    'YS_VB12': 'medical',
    'HbA1a': 'medical',
    'AO': 'medical',
    'LA': 'medical',
    'LVD': 'medical',
    'LVS': 'medical',
    'IVS': 'medical',
    'LVPW': 'medical',
    'PA': 'medical',
    'sPAP': 'medical',
    'LVEF': 'medical',
    
    // 社会经济
    'D1': 'social',
    'D2': 'social',
    'D3': 'social',
    'D4': 'social',
    'D5': 'social',
    'E1': 'social',
    'E2': 'social',
    'E3': 'social',
    'E4': 'social',
    'E5': 'social'
};

// 变量描述映射（基于codebook）
const descriptionMapping = {
    'SearchTime': '查询时间',
    'A2': '性别',
    'A4': '出生日期',
    'A5': '婚姻状况',
    'A6': '教育程度',
    'A7': '职业',
    'A8': '收入',
    'WBC': '白细胞计数',
    'NEUT2': '中性粒细胞百分比',
    'LYMPH2': '淋巴细胞百分比',
    'MONO2': '单核细胞百分比',
    'EOS2': '嗜酸性粒细胞百分比',
    'BASO2': '嗜碱性粒细胞百分比',
    'NEUT': '中性粒细胞绝对值',
    'LYMPH': '淋巴细胞绝对值',
    'MONO': '单核细胞绝对值',
    'EOS': '嗜酸性粒细胞绝对值',
    'BASO': '嗜碱性粒细胞绝对值',
    'RBC': '红细胞计数',
    'HGB': '血红蛋白',
    'HCT': '红细胞压积',
    'MCV': '平均红细胞体积',
    'MCH': '平均红细胞血红蛋白含量',
    'MCHC': '平均红细胞血红蛋白浓度',
    'PLT': '血小板计数',
    'MPV': '平均血小板体积',
    'ALT': '丙氨酸氨基转移酶',
    'TP': '总蛋白',
    'ALB': '白蛋白',
    'CR': '肌酐',
    'BUN': '尿素氮',
    'HCY': '同型半胱氨酸',
    'GLU': '血糖',
    'Ca': '钙',
    'P': '磷',
    'hs_CRP': '超敏C反应蛋白',
    'TC': '总胆固醇',
    'TG': '甘油三酯',
    'HDL_C': '高密度脂蛋白胆固醇',
    'LDL_C': '低密度脂蛋白胆固醇',
    'Lp_a': '脂蛋白a',
    'UALB': '尿白蛋白',
    'UCr': '尿肌酐',
    'T': '睾酮',
    'INS': '胰岛素',
    'TG_Ab': '甲状腺球蛋白抗体',
    'TPO_Ab': '甲状腺过氧化物酶抗体',
    'FT3': '游离三碘甲状腺原氨酸',
    'FT4': '游离甲状腺素',
    'TSH': '促甲状腺激素',
    'HbA1b': '糖化血红蛋白A1b',
    'GHB': '糖化血红蛋白',
    'HbA1c': '糖化血红蛋白A1c',
    'MBG': '平均血糖',
    'GDX1': '血糖指标1',
    'GDX2': '血糖指标2',
    'GDX3': '血糖指标3',
    'GDX4': '血糖指标4',
    'YS_FA': '叶酸',
    'YS_VB12': '维生素B12',
    'HbA1a': '糖化血红蛋白A1a',
    'AO': '主动脉根部内径',
    'LA': '左心房内径',
    'LVD': '左心室舒张末期内径',
    'LVS': '左心室收缩末期内径',
    'IVS': '室间隔厚度',
    'LVPW': '左心室后壁厚度',
    'PA': '肺动脉内径',
    'sPAP': '肺动脉收缩压',
    'LVEF': '左心室射血分数'
};

// 处理数据
function processData() {
    console.log('开始处理数据...');
    
    // 读取df_browse.csv
    const browsePath = path.join(__dirname, '..', 'data', 'df_browse.csv');
    const browseData = readCSV(browsePath);
    
    if (browseData.length === 0) {
        console.error('无法读取df_browse.csv文件');
        return;
    }
    
    console.log(`读取到 ${browseData.length} 条变量记录`);
    
    // 处理变量数据
    const processedVariables = browseData.map(row => {
        const variable = row.skim_variable || row.variable;
        const type = row.skim_type || row.type;
        
        const processed = {
            variable: variable,
            type: type,
            n_missing: parseInt(row.n_missing) || 0,
            complete_rate: parseFloat(row.complete_rate) || 0,
            category: categoryMapping[variable] || 'other',
            description: descriptionMapping[variable] || variable,
            notes: ''
        };
        
        // 添加数值型变量的统计信息
        if (type === 'numeric') {
            processed.mean = parseFloat(row.numeric_mean) || null;
            processed.sd = parseFloat(row.numeric_sd) || null;
            processed.min = parseFloat(row.numeric_p0) || null;
            processed.max = parseFloat(row.numeric_p100) || null;
            processed.q25 = parseFloat(row.numeric_p25) || null;
            processed.median = parseFloat(row.numeric_p50) || null;
            processed.q75 = parseFloat(row.numeric_p75) || null;
        }
        
        return processed;
    });
    
    // 生成JSON文件
    const outputPath = path.join(__dirname, 'variables-data.json');
    fs.writeFileSync(outputPath, JSON.stringify(processedVariables, null, 2), 'utf-8');
    
    console.log(`数据处理完成，已生成 ${outputPath}`);
    console.log(`共处理 ${processedVariables.length} 个变量`);
    
    // 生成统计摘要
    const summary = {
        total_variables: processedVariables.length,
        by_type: {},
        by_category: {},
        missing_data_summary: {
            variables_with_missing: processedVariables.filter(v => v.n_missing > 0).length,
            total_missing_values: processedVariables.reduce((sum, v) => sum + v.n_missing, 0)
        }
    };
    
    // 按类型统计
    processedVariables.forEach(v => {
        summary.by_type[v.type] = (summary.by_type[v.type] || 0) + 1;
    });
    
    // 按分类统计
    processedVariables.forEach(v => {
        summary.by_category[v.category] = (summary.by_category[v.category] || 0) + 1;
    });
    
    const summaryPath = path.join(__dirname, 'data-summary.json');
    fs.writeFileSync(summaryPath, JSON.stringify(summary, null, 2), 'utf-8');
    
    console.log('数据摘要:', summary);
}

// 如果直接运行此脚本
if (require.main === module) {
    processData();
}

module.exports = { processData, readCSV };