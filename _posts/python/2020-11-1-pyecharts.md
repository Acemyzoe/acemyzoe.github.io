---
title: pyecharts
tags: python
---

# pyecharts

[pyecharts.org](https://pyecharts.org/)

```python
def draw_charts(userId):
    """
    绘图
    """
    print("用户编号：",userId)
    data_x,data_y,data_x_2,data_y_2,data_x_3,data_y_3 = load_data(userId)
    line = (
        Line()
        .add_xaxis(data_x)
        .add_xaxis(data_x_2)
        .add_xaxis(data_x_3)
        .add_yaxis("电流有效值",data_y)
        .add_yaxis("合并后的电流有效值",data_y_2)
        .add_yaxis("电流变化量值",data_y_3)
        .set_global_opts(
            title_opts=opts.TitleOpts(
                title="A",
                subtitle="ace",
                ),
            brush_opts=opts.BrushOpts(tool_box = ['rect','polygon','lineX','lineY','keep','clear',]),
            tooltip_opts=opts.TooltipOpts(trigger="axis", axis_pointer_type="cross"),
            legend_opts=opts.LegendOpts(pos_left="center"),
            datazoom_opts=[
                opts.DataZoomOpts(is_show=True,type_="inside", range_start=0, range_end=100),
            ],
            toolbox_opts=opts.ToolboxOpts(is_show=True),
            xaxis_opts=opts.AxisOpts(type_="time",min_="dataMin",boundary_gap=False),
            )
        .set_series_opts(label_opts=opts.LabelOpts(is_show=False)) # 隐藏数值标签
    )
    if not os.path.exists("charts"):os.makedirs("charts")
    (
        Grid(init_opts=opts.InitOpts(width="1024px", height="1024px",page_title=userId))
        .add(chart=line, grid_opts=opts.GridOpts(pos_left=50, pos_right=50, height="35%"))
        .render("./charts/" + str(userId) + ".html")
    )
```

