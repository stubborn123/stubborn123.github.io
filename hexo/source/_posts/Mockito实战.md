title: Mockito实战
author: ZP
date: 2023-04-19 16:40:35
tags: Mockito
sticky: true
---
为什么要有个Mockito，本身Junit就可以做单元测试，为什么还要加一个Mcokito作为单元测试框架。

实际上两者不矛盾，甚至两者是搭配着使用的，确切的说Mockito是一个单元测试模拟框架，来帮助发现隐藏bug，提高代码质量。为什么会有这样的作用呢，具体一点的实践场景都有哪些？

首先Mockito注重的是一个模拟，本身mock本意就有模仿假装的意思在里面，假设我们的代码需要跟第三方联调，我们需要人家给我们数据，设置前置条件。实际工作中就知道，工作本身可能不太难，但是和人交流协同有时候更消耗时间。那我们可不可以模拟“别人”，给我们提供我们设想的数据，这样我们就不用看别人“眼色”。

还有一种就是我们需要考虑各种测试场景，这里避免不了各种脏数据产生，导致测试环境什么样的数据都有，这些脏数据可能会影响后面的测试，我们可以模拟各种场景，不产生脏数据。

##### TDD测试驱动开发
首先我们要理解一个概念先，首先并不是什么代码都可以很方便的单元测试。这也是为什么我们不太愿意写单元测试的原因之一，麻烦觉得没意义。

但是我们如果要理解一个概念TDD测试驱动开发，去理解写代码，能提高我们对需求的理解和提高代码的可维护性。以下是TDD的官方表述：
```
TDD（Test-Driven Development，测试驱动开发）是一种软件开发方法，它强调在编写代码之前先编写测试用例，然后只编写足够的代码使测试用例通过。TDD的基本思想是：先写测试，再写代码，然后重构代码，以确保代码的正确性和可维护性。

TDD的流程通常被称为红-绿-重构（Red-Green-Refactor）：

红：编写测试用例，运行测试用例，测试用例失败（红色）。

绿：编写足够的代码使测试用例通过，运行测试用例，测试用例通过（绿色）。

重构：重构代码，以提高代码的质量和可维护性，然后重新运行测试用例，确保测试用例仍然通过。

TDD的目标是通过测试来驱动开发，以确保代码的正确性和可维护性，同时提高开发效率和项目质量。TDD还可以帮助开发人员更好地理解需求，促进团队协作，提高系统稳定性。
```

试想一下，我们重构代码，对应的测试案例在maven构建时自动处理（前提是比不要把测试的给屏蔽了），能不能通过，构建的时候就走了一遍。

同样在编写的时候，我们考虑到测试，做到将需求明确和逻辑梳理，把各个场景考虑清楚，避免过度测试，因为有时候很多地方测试测的时候，会出现很多重复测试某个场景。

##### Mockito基础
在理解TDD的概念，我们可以借助Mockito来帮助我们完善单元测试，可以帮助哦我们去模拟各种场景，各种参数。

```
在工程中使用 Mockito，需要按照以下步骤：

添加 Mockito 依赖项：在项目的构建文件中添加 Mockito 的依赖项，例如使用 Maven 的项目，在 pom.xml 文件中添加以下依赖项：

<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <version>3.12.4</version>
    <scope>test</scope>
</dependency>
创建测试用例：创建一个测试类，并在类中添加测试方法。使用 @Test 注解标记测试方法。

创建模拟对象：在测试方法中，使用 Mockito.mock() 方法创建一个模拟对象。例如：

// 创建一个模拟对象
List<String> mockedList = Mockito.mock(List.class);
设置模拟对象的行为：使用 Mockito.when() 方法设置模拟对象的行为。例如：

// 设置模拟对象的行为
Mockito.when(mockedList.get(0)).thenReturn("first");
运行测试：使用 JUnit 运行测试用例，例如使用 @RunWith 注解和 @Test 注解。例如：

// 运行测试用例
@RunWith(MockitoJUnitRunner.class)
public class MyTest {
    @Test
    public void testMethod() {
        // 测试方法中使用模拟对象
        List<String> mockedList = Mockito.mock(List.class);
        Mockito.when(mockedList.get(0)).thenReturn("first");
        assertEquals("first", mockedList.get(0));
    }
}
以上是使用 Mockito 的基本步骤，可以根据具体的测试场景和要求，使用 Mockito 提供的其他 API 和功能，例如验证模拟对象的方法调用次数、设置模拟对象的默认行为等。
```

以上只是一个大致的步骤，实际上我们使用的时候，肯定要比这复杂得多，举个例子，我们的一个service类，里面有很多依赖需要注入的bean，有的是数据库DAO层，有的是别的component。这时候我们该怎么做，怎么改来实现我们的预想目标。

##### Mockito实战
接上面，首先我们写的一些业务代码，由于设计不好，写的像一条“布”，一样一步一步去写，由于业务的不断修改，就变得又臭又长的“布”。首先我们需要把代码写好，做好设计，如果你对一个很复杂的做接口测试，你会发现涉及到的东西太多，Mock了一大堆，场景复杂自己都不知道该如何是好。

######  (1)编写代码
第一步就是编写好代码，除了新写，也包括改造重构

对于TDD代码的要求
```
TDD（测试驱动开发）对代码设计的要求主要包括以下几个方面：

可测试性：代码必须易于测试，即能够轻松地编写测试用例并进行测试。为了实现可测试性，代码应该遵循良好的编码规范和设计原则，例如单一职责原则、开闭原则、依赖倒置原则等。

可扩展性：代码必须易于扩展，即能够轻松地添加新的功能或修改现有的功能，而不会影响现有的功能或导致代码重构。为了实现可扩展性，代码应该遵循良好的设计模式和架构模式，例如工厂模式、策略模式、MVC模式等。

可维护性：代码必须易于维护，即能够轻松地修改和更新代码，而不会影响现有的功能或导致代码重构。为了实现可维护性，代码应该遵循良好的编码规范和设计原则，例如代码重构、注释、命名规范等。

可重用性：代码必须易于重用，即能够轻松地将代码移植到其他项目或模块中，从而提高代码的复用性和可维护性。为了实现可重用性，代码应该遵循良好的设计模式和架构模式，例如模板方法模式、适配器模式、代理模式等。

总之，TDD要求代码具有良好的可测试性、可扩展性、可维护性和可重用性，以确保代码的正确性和可维护性，同时提高开发效率和项目质量。
```

###### （2）Mock注解的使用 

在代码写好后，我们要去测试，我们要利用Mockito来模拟对应的对象。

创建 Mock 对象的语法为 mock(class or interface)。

```
mock(Class classToMock);
 mock(Class classToMock, String name)
 mock(Class classToMock, Answer defaultAnswer)
 mock(Class classToMock, MockSettings mockSettings)
 mock(Class classToMock, ReturnValues returnValues)
```
或者
```
 @Mock
    private MaterialAllocateOrderMapper materialAllocateOrderMapper;

    @Mock
    private MaterialAllocateOrderDetailMapper materialAllocateOrderDetailMapper;
```

我们实际工作中会出现AService依赖BService，这种情况怎么处理呢？

实际上我们这里要模拟的是BService，需要自动注入模拟对象，这里我们就用到@InjectMocks注解。


```
    @Mock
    private MaterialAllocateOrderMapper materialAllocateOrderMapper;

    @Mock
    private MaterialAllocateOrderDetailMapper materialAllocateOrderDetailMapper;

    @InjectMocks
    private MaterialAllocateOrderSupport orderStatusBuildRequest;
```
设置对象调用的预期返回值

原则上我们mock的对象，没有设置默认或者于其返回值，调用里面的方法，什么忙都不会做，但实际上我们需要他们“返回”一些我们需要的东西，这就是要设置预期返回值。

通过 when(mock.someMethod()).thenReturn(value) 来设定 Mock 对象某个方法调用时的返回值。

```
    @Test
    public void testBuildOrderStatusRequest() {
       handleTestBuildOrderStatusRequest();
    }


    private OrderStatusBuildRequest handleTestBuildOrderStatusRequest() {

        // 设置模拟的方法调用返回值
        when(materialAllocateOrderMapper.findById(anyLong())).thenReturn(allocateOrderDO);
        when(materialAllocateOrderDetailMapper.findByAllocateOrderNo(anyString(), anyLong())).thenReturn(detailDOList);

        // 调用被测试的方法
//        OrderStatusBuildRequest result = orderStatusBuildRequest.buildOrderStatusRequest(1L, 1);
        OrderStatusBuildRequest result = orderStatusBuildRequest.buildOrderStatusRequest(1L, 0);

        // 断言返回值是否符合预期
        Integer status = result.getStatus();
        Assert.assertTrue(result!=null);

        return result;
    }
```

但是有时候我们需要给定一些值，作为条件，比如我们模拟用户，首先要把用户信息先给进去，这里我们直接用@Before注解就可以


`@Before` 是 JUnit 框架提供的一个注解，用于标记在每个测试方法执行之前需要执行的方法。通常，在测试方法执行之前需要进行一些初始化操作，例如创建对象、初始化变量等。使用 `@Before` 注解可以将这些初始化操作封装到一个方法中，并在每个测试方法执行之前自动执行。

使用 `@Before` 注解时，需要满足以下条件：

1. 被测试类中需要有一个方法，它使用 `@Before` 注解进行标记。

2. `@Before` 注解标记的方法必须是公共方法（public），没有参数，并且没有返回值。

3. `@Before` 注解标记的方法会在每个测试方法执行之前自动执行。

例如：

```java
public class MyTest {
    private MyObject myObject;

    @Before
    public void setUp() {
        myObject = new MyObject();
    }

    @Test
    public void testMethod1() {
        // 测试方法1
    }

    @Test
    public void testMethod2() {
        // 测试方法2
    }
}
```

在上面的例子中，`MyTest` 类中有一个 `setUp()` 方法，它使用 `@Before` 注解进行标记。在 `setUp()` 方法中，创建了一个 `MyObject` 对象，并将其赋值给 `myObject` 属性。在测试方法中，可以使用 `myObject` 属性进行测试。

使用 `@Before` 注解可以将测试方法中的重复代码提取到一个公共的方法中，避免代码重复，提高测试代码的可读性和可维护性。


下面我发一下具体的代码demo
```java


    @Mock
    private MaterialAllocateOrderMapper materialAllocateOrderMapper;

    @Mock
    private MaterialAllocateOrderDetailMapper materialAllocateOrderDetailMapper;

    @InjectMocks
    private MaterialAllocateOrderSupport orderStatusBuildRequest;

    @Mock
    private MaterialAllocateOutStorageStatusService statusService;

    @Mock
    private OutStorageMapper outStorageMapper;

    @Mock
    private OutStorageDetailMapper outStorageDetailMapper;

    private AllocateOrderDO allocateOrderDO;

    private List<AllocateOrderDetailDO> detailDOList;

    private OrderStatusBuildRequest testRequest;

    private List<OrderDetailStatusBuildRequest> requestDetailList;

    private OutStorageDO outStorageDO;

    List<OutStorageDetailDO> outStorageDetailDOList;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);

        allocateOrderDO = new AllocateOrderDO();
        allocateOrderDO.setId(1L);
        allocateOrderDO.setAllocateOrderNo("123");
        allocateOrderDO.setMerchantId(1L);

        AllocateOrderDetailDO detailDO1 = new AllocateOrderDetailDO();
        detailDO1.setId(11L);
        detailDO1.setAllocateStatus(AllocateOrderStatus.TO_CONFIRM.getValue());
        detailDO1.setAllocateOrderNo("123");
        detailDO1.setOutStorageDetailId(21L);
        detailDO1.setOutStorageId(2L);

        AllocateOrderDetailDO detailDO2 = new AllocateOrderDetailDO();
        detailDO2.setId(12L);
        detailDO2.setAllocateStatus(AllocateOrderStatus.TO_CONFIRM.getValue());
        detailDO2.setAllocateOrderNo("123");
        detailDO2.setOutStorageDetailId(22L);
        detailDO2.setOutStorageId(2L);

        AllocateOrderDetailDO detailDO3 = new AllocateOrderDetailDO();
        detailDO3.setId(13L);
        detailDO3.setAllocateStatus(AllocateOrderStatus.TO_CONFIRM.getValue());
        detailDO3.setAllocateOrderNo("123");
        detailDO3.setOutStorageDetailId(23L);
        detailDO3.setOutStorageId(2L);

        AllocateOrderDetailDO detailDO4 = new AllocateOrderDetailDO();
        detailDO4.setId(14L);
        detailDO4.setAllocateStatus(AllocateOrderStatus.TO_CONFIRM.getValue());
        detailDO4.setAllocateOrderNo("123");
        detailDO4.setOutStorageDetailId(24L);
        detailDO4.setOutStorageId(2L);

        detailDOList = new ArrayList<>();
        detailDOList.add(detailDO1);
        detailDOList.add(detailDO2);
        detailDOList.add(detailDO3);
        detailDOList.add(detailDO4);



        ////以下是测试状态转换的预处理
//        testRequest = new OrderStatusBuildRequest();
//        testRequest.setOrderType(OrderType.MATERIAL_ALLOCATE);
//        testRequest.setOrderStatus();
//        testRequest.setOrderOperateType();
//        testRequest.setNeedApproval();
//        testRequest.setApproval();
//        testRequest.setOrderId();
//        testRequest.setStatus();
//
//        requestDetailList = new ArrayList<>();
//
//        OrderDetailStatusBuildRequest detailRequest1 = new OrderDetailStatusBuildRequest();
//        detailRequest1.setOrderType();
//        detailRequest1.setOrderStatus();
//        detailRequest1.setOrderOperateType();
//        detailRequest1.setNeedApproval();
//        detailRequest1.setApproval();
//        detailRequest1.setStatus();
//        requestDetailList.add(detailRequest1);
//
//        OrderDetailStatusBuildRequest detailRequest2 = new OrderDetailStatusBuildRequest();
//        requestDetailList.add(detailRequest2);

         outStorageDO = new OutStorageDO();
         outStorageDO.setId(2L);


        outStorageDetailDOList = new ArrayList<>();
        OutStorageDetailDO outStorageDetailDO1 = new OutStorageDetailDO();
        outStorageDetailDO1.setId(21L);
        outStorageDetailDO1.setOutStorageId(2L);
        outStorageDetailDOList.add(outStorageDetailDO1);

        OutStorageDetailDO outStorageDetailDO2 = new OutStorageDetailDO();
        outStorageDetailDO2.setId(22L);
        outStorageDetailDO2.setOutStorageId(2L);
        outStorageDetailDOList.add(outStorageDetailDO2);

        OutStorageDetailDO outStorageDetailDO3 = new OutStorageDetailDO();
        outStorageDetailDO3.setId(23L);
        outStorageDetailDO3.setOutStorageId(2L);
        outStorageDetailDOList.add(outStorageDetailDO3);

        OutStorageDetailDO outStorageDetailDO4 = new OutStorageDetailDO();
        outStorageDetailDO4.setId(24L);
        outStorageDetailDO4.setOutStorageId(2L);
        outStorageDetailDOList.add(outStorageDetailDO4);



    }

    @Test
    public void testBuildOrderStatusRequest() {
       handleTestBuildOrderStatusRequest();
    }


    private OrderStatusBuildRequest handleTestBuildOrderStatusRequest() {

        // 设置模拟的方法调用返回值
        when(materialAllocateOrderMapper.findById(anyLong())).thenReturn(allocateOrderDO);
        when(materialAllocateOrderDetailMapper.findByAllocateOrderNo(anyString(), anyLong())).thenReturn(detailDOList);

        // 调用被测试的方法
//        OrderStatusBuildRequest result = orderStatusBuildRequest.buildOrderStatusRequest(1L, 1);
        OrderStatusBuildRequest result = orderStatusBuildRequest.buildOrderStatusRequest(1L, 0);

        // 断言返回值是否符合预期
        Integer status = result.getStatus();
        Assert.assertTrue(result!=null);

        return result;
    }


    /**
     * 测试调拨单出库状态转换，以下情景：
     * （1）要审批        outStorageStatus = 2
     *
     * （2）不要审批：调拨详情都是待确认   outStorageStatus = 11
     * （3）不要审批：调拨详情都是已完成   outStorageStatus = 1
     * （4）不要审批：调拨详情都是已取消    outStorageStatus = 6
     * （5）不要审批：调拨详情都是已驳回    outStorageStatus = 6
     * （6）不要审批：调拨详情已完成，已取消，已驳回，待确认 outStorageStatus = 11
     * （7）不要审批：调拨详情已完成，待确认  outStorageStatus = 11
     * （8）不要审批：调拨详情已取消，待确认  outStorageStatus = 11
     * （9）不要审批：调拨详情已取消，已完成  outStorageStatus = 1
     * （10）不要审批：审批驳回  outStorageStatus = 9
     * （11）不要审批：审批撤销
     *
     */
    @Test
    public void testHandleMaterialAllocateOrderOutStorageStatus() {


        typeDetailDOListWithOutApproval(11);

        OrderStatusBuildRequest request = handleTestBuildOrderStatusRequest();

        statusService.getStatus(request);

        when(outStorageMapper.findById(anyLong())).thenReturn(outStorageDO);
        when(outStorageDetailMapper.findByOutStorageId(anyLong())).thenReturn(outStorageDetailDOList);
        when(materialAllocateOrderDetailMapper.selectList(any())).thenReturn(detailDOList);


        when(materialAllocateOrderMapper.findById(anyLong())).thenReturn(allocateOrderDO);
        when(outStorageDetailMapper.updateBatchById(anyList())).thenReturn(1);

        orderStatusBuildRequest.handleMaterialAllocateOrderOutStorageStatus(request, 2L);


        verify(statusService).getStatus(eq(request));
//        verify(outStorageMapper).findById(eq(outStorageId));
//        verify(outStorageDetailMapper).findByOutStorageId(eq(outStorageId));
//        verify(orderStatus).findDetailByDetailIdList(anyList(), eq(outStorageDO.getMerchantId()));
//        verify(outStorageMapper).updateById(eq(outStorageDO));
//        verify(outStorageDetailMapper).updateBatchById(eq(outStorageDetailDOList));
    }


    /**
     * 不审批场景类型
     * @param type
     * @return
     */
    private List<AllocateOrderDetailDO> typeDetailDOListWithOutApproval(Integer type) {

        List<AllocateOrderDetailDO> handleDetailDOList = detailDOList;
        //2 不要审批：调拨详情都是待确认
        if (type == 2) {
            for (AllocateOrderDetailDO detailDO : handleDetailDOList) {
                detailDO.setAllocateStatus(AllocateOrderStatus.TO_CONFIRM.getValue());
            }
        }

        //3不要审批：调拨详情都是已完成   outStorageStatus = 11
        else if (type == 3) {
            for (AllocateOrderDetailDO detailDO : handleDetailDOList) {
                detailDO.setAllocateStatus(AllocateOrderStatus.FINISHED.getValue());
            }
        }
        //4 不要审批：调拨详情都是已取消
        else if (type == 4) {
            for (AllocateOrderDetailDO detailDO : handleDetailDOList) {
                detailDO.setAllocateStatus(AllocateOrderStatus.CANCEL.getValue());
            }
        }

        //（5）不要审批：调拨详情都是已驳回
        else if (type == 5) {
            for (AllocateOrderDetailDO detailDO : handleDetailDOList) {
                detailDO.setAllocateStatus(AllocateOrderStatus.REJECT.getValue());
            }
        }
        //6不要审批：调拨详情已完成，已取消，已驳回，待确认
        else if (type == 6) {
            handleDetailDOList.get(0).setAllocateStatus(AllocateOrderStatus.FINISHED.getValue());
            handleDetailDOList.get(1).setAllocateStatus(AllocateOrderStatus.CANCEL.getValue());
            handleDetailDOList.get(2).setAllocateStatus(AllocateOrderStatus.REJECT.getValue());
            handleDetailDOList.get(3).setAllocateStatus(AllocateOrderStatus.TO_CONFIRM.getValue());
        }

        // 7 不要审批：调拨详情已完成，待确认
        else if (type == 7) {
            handleDetailDOList.get(0).setAllocateStatus(AllocateOrderStatus.FINISHED.getValue());
            handleDetailDOList.get(1).setAllocateStatus(AllocateOrderStatus.FINISHED.getValue());
            handleDetailDOList.get(2).setAllocateStatus(AllocateOrderStatus.TO_CONFIRM.getValue());
            handleDetailDOList.get(3).setAllocateStatus(AllocateOrderStatus.TO_CONFIRM.getValue());
        }
        // 8 不要审批：调拨详情已取消，待确认
        else if (type == 8) {
            handleDetailDOList.get(0).setAllocateStatus(AllocateOrderStatus.CANCEL.getValue());
            handleDetailDOList.get(1).setAllocateStatus(AllocateOrderStatus.CANCEL.getValue());
            handleDetailDOList.get(2).setAllocateStatus(AllocateOrderStatus.TO_CONFIRM.getValue());
            handleDetailDOList.get(3).setAllocateStatus(AllocateOrderStatus.TO_CONFIRM.getValue());
        }

        //9 不要审批：调拨详情已取消，已完成
        else if (type == 9) {
            handleDetailDOList.get(0).setAllocateStatus(AllocateOrderStatus.CANCEL.getValue());
            handleDetailDOList.get(1).setAllocateStatus(AllocateOrderStatus.CANCEL.getValue());
            handleDetailDOList.get(2).setAllocateStatus(AllocateOrderStatus.FINISHED.getValue());
            handleDetailDOList.get(3).setAllocateStatus(AllocateOrderStatus.FINISHED.getValue());
        }

        //10不要审批：审批驳回
        else if (type == 10) {
            for (AllocateOrderDetailDO detailDO : handleDetailDOList) {
                detailDO.setAllocateStatus(AllocateOrderStatus.APPROVAL_REJECT.getValue());
            }
        }
        // 11 不要审批：审批撤销
        else if (type == 11) {
            for (AllocateOrderDetailDO detailDO : handleDetailDOList) {
                detailDO.setAllocateStatus(AllocateOrderStatus.APPROVAL_REVOKE.getValue());
            }
        }
        return handleDetailDOList;
    }

```