## 内存监视器
用于监视内存是否正常释放。

## 用法
#### 创建一个内存监视对象
```haxe
var mm = new MemoryMonitor();
```

#### 观察对象
```haxe
mm.watch(obj);
```

#### 删除观察对象
```haxe
// 删除的时候，会把所有相同类型的对象删除
mm.unwatch(obj);
```

#### 引用数据
可输出相关的log数据
```haxe
trace(mm.log());
```