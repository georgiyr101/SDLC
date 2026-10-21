package FinanceTrackerModel {
  private import ScalarValues::*;
  
  package Types {
    private import ScalarValues::*;
    
    attribute def Amount {
      specializes Real;
    }
    
    attribute def Percent {
      specializes Real;
    }
    
    attribute def IsoDate {
      specializes String;
    }
    
    attribute def CurrencyCode {
      specializes String;
    }
    
    enum def TransactionType {
      income;
      expense;
      transfer;
    }
    
    enum def CategoryType {
      income;
      expense;
    }
    
    enum def AccountType {
      cash;
      card;
      deposit;
      other;
    }
    
    enum def BudgetStatus {
      normal;
      warning;
      exceeded;
    }
    
    enum def Priority {
      must;
      should;
      could;
    }
  }
  
  package Domain {
    private import ScalarValues::*;
    private import Types::*;
    
    item def Account {
      attribute id : Integer;
      
      attribute name : String;
      
      attribute kind : AccountType;
      
      attribute currency : CurrencyCode;
      
      attribute initialBalance : Amount;
      
      attribute archived : Boolean;
    }
    
    item def Category {
      attribute id : Integer;
      
      attribute name : String;
      
      attribute kind : CategoryType;
      
      attribute archived : Boolean;
      
      ref item parentCategory : Category [0..1];
    }
    
    item def Transaction {
      attribute id : Integer;
      
      attribute date : IsoDate;
      
      attribute amount : Amount;
      
      attribute kind : TransactionType;
      
      attribute description : String;
      
      ref item account : Account [1];
      
      ref item targetAccount : Account [0..1];
      
      ref item category : Category [0..1];
    }
    
    item def Budget {
      attribute id : Integer;
      
      attribute month : String;
      
      attribute limitAmount : Amount;
      
      ref item category : Category [1];
    }
    
    item def CategoryRule {
      attribute id : Integer;
      
      attribute keyword : String;
      
      attribute priority : Integer;
      
      ref item category : Category [1];
    }
    
    item def AppSettings {
      attribute baseCurrency : CurrencyCode;
      
      attribute dateFormat : String;
      
      attribute monthStartDay : Integer;
    }
    
    item def TransactionDraft {
      attribute amount : Amount;
      
      attribute date : IsoDate;
      
      attribute kind : TransactionType;
      
      attribute description : String;
    }
    
    item def CsvFile {
      attribute path : String;
      
      attribute encoding : String = "UTF-8";
      
      attribute delimiter : String = ";";
    }
    
    item def DataQuery;
    
    item def DataResult;
    
    item def SqlStatement;
    
    item def SqlResult;
  }
  
  package Requirements {
    private import ScalarValues::*;
    private import Types::*;
    
    requirement def SrsRequirement {
      doc /* Базовый тип требования SRS. Приоритет — по MoSCoW (Must / Should / Could). */
      
      attribute priority : Priority;
    }
    
    requirement def InterfaceRequirement {
      specializes FinanceTrackerModel::Requirements::SrsRequirement;
    }
    
    requirement def FunctionalRequirement {
      specializes FinanceTrackerModel::Requirements::SrsRequirement;
    }
    
    requirement def QualityRequirement {
      specializes FinanceTrackerModel::Requirements::SrsRequirement;
    }
    
    requirement def DesignConstraintRequirement {
      specializes FinanceTrackerModel::Requirements::SrsRequirement;
    }
    
    package Interfaces {
      requirement 'REQ-INT-001' mainWindowStructure : InterfaceRequirement {
        doc /* Главное окно с разделами: Обзор, Операции, Счета, Категории, Бюджет, Отчёты, Настройки. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-INT-002' transactionFormValidation : InterfaceRequirement {
        doc /* Форма операции (тип, сумма, дата, счёт, категория, описание) и валидация ввода с сообщением рядом с полем. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-INT-003' uiLocalization : InterfaceRequirement {
        doc /* Интерфейс на русском языке; тексты хранятся во внешних файлах ресурсов. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-INT-004' uiAccessibility : InterfaceRequirement {
        doc /* Основные действия доступны с клавиатуры; статусы бюджета передаются не только цветом. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-INT-005' minimumResolution : InterfaceRequirement {
        doc /* Работа на стандартном ПК; окно корректно при разрешении не менее 1024x720. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-INT-006' databaseAccessInterface : InterfaceRequirement {
        doc /* Доступ к SQLite через JDBC и интерфейсы-репозитории. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-INT-007' csvFormat : InterfaceRequirement {
        doc /* CSV: UTF-8, разделитель ';', колонки date, type, amount, account, category, description. */
        
        attribute :>> priority = Priority::must;
      }
    }
    
    package Functional {
      requirement 'REQ-FUNC-001' accountCreateEdit : FunctionalRequirement {
        doc /* Создание и редактирование счёта (название, тип, валюта, начальный баланс). */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-002' balanceCalculation : FunctionalRequirement {
        doc /* Расчёт баланса каждого счёта и суммарного баланса. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-003' accountArchiving : FunctionalRequirement {
        doc /* Архивация счёта с сохранением истории операций. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-FUNC-004' addIncomeExpense : FunctionalRequirement {
        doc /* Добавление операций-доходов и операций-расходов. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-005' editDeleteTransaction : FunctionalRequirement {
        doc /* Редактирование и удаление операций с подтверждением и пересчётом балансов. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-006' transactionListFilter : FunctionalRequirement {
        doc /* Список операций: сортировка, фильтры по периоду, счёту, категории, типу, поиск по описанию. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-007' transfersBetweenAccounts : FunctionalRequirement {
        doc /* Переводы между счетами; перевод не является доходом или расходом. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-FUNC-008' recurringTransactions : FunctionalRequirement {
        doc /* Регулярные операции (ежедневно, еженедельно, ежемесячно). */
        
        attribute :>> priority = Priority::could;
      }
      
      requirement 'REQ-FUNC-009' defaultCategories : FunctionalRequirement {
        doc /* Набор категорий по умолчанию (7 расходных и 4 доходных). */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-010' categoryManagement : FunctionalRequirement {
        doc /* Создание, переименование и архивация категорий; запрет удаления используемых. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-011' autoCategorization : FunctionalRequirement {
        doc /* Автокатегоризация по правилам «описание содержит X -> категория Y». */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-FUNC-012' monthlyCategoryLimits : FunctionalRequirement {
        doc /* Месячные лимиты расходов по категориям. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-013' budgetExecutionControl : FunctionalRequirement {
        doc /* Контроль исполнения бюджета: план, факт, остаток, процент; статусы при 80 % и 100 %. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-014' totalLimitAndCopyBudget : FunctionalRequirement {
        doc /* Общий месячный лимит и копирование бюджета с прошлого месяца. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-FUNC-015' expensePieChart : FunctionalRequirement {
        doc /* Круговая диаграмма расходов по категориям за период. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-016' incomeExpenseBarChart : FunctionalRequirement {
        doc /* Столбчатая диаграмма «доходы и расходы» по месяцам (до 12 месяцев). */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-017' balanceDynamicsChart : FunctionalRequirement {
        doc /* График динамики суммарного баланса. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-FUNC-018' overviewScreen : FunctionalRequirement {
        doc /* Экран «Обзор»: показатели месяца, топ-5 категорий, индикаторы бюджета. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-019' liveViewRefresh : FunctionalRequirement {
        doc /* Автоматическое обновление диаграмм, индикаторов и балансов без перезапуска. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-020' csvExport : FunctionalRequirement {
        doc /* Экспорт операций за период в CSV. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-FUNC-021' csvImport : FunctionalRequirement {
        doc /* Импорт из CSV с предпросмотром и отчётом о пропущенных строках. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-FUNC-022' backupRestore : FunctionalRequirement {
        doc /* Резервное копирование и восстановление БД. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-FUNC-023' appSettings : FunctionalRequirement {
        doc /* Настройки: валюта, формат дат, расчётный день месяца. */
        
        attribute :>> priority = Priority::should;
      }
    }
    
    package Quality {
      requirement 'REQ-PERF-001' startupTime : QualityRequirement {
        doc /* Главное окно не позднее 3 с после запуска при 10 000 операций. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-PERF-002' listResponseTime : QualityRequirement {
        doc /* Открытие списка операций, фильтр и сортировка не дольше 1 с. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-PERF-003' chartRenderTime : QualityRequirement {
        doc /* Построение диаграммы за период до 12 месяцев не дольше 1 с. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-PERF-004' memoryFootprint : QualityRequirement {
        doc /* Не более 300 МБ оперативной памяти при 10 000 операций. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-SEC-001' localOnlyNoTelemetry : QualityRequirement {
        doc /* Данные только локально; без сетевых соединений и телеметрии. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-SEC-002' pinProtection : QualityRequirement {
        doc /* Защита запуска PIN-кодом, хранится только соленый хеш. */
        
        attribute :>> priority = Priority::could;
      }
      
      requirement 'REQ-SEC-003' inputValidationParametrizedSql : QualityRequirement {
        doc /* Параметризованные SQL-запросы и валидация всех внешних данных. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-REL-001' transactionalWrites : QualityRequirement {
        doc /* Транзакционная запись; подтверждённые изменения не теряются при аварии. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-REL-002' corruptedDbHandling : QualityRequirement {
        doc /* При повреждении БД — диалог восстановления без аварийного завершения. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-REL-003' moneyArithmeticCorrectness : QualityRequirement {
        doc /* Денежные расчёты на BigDecimal, 2 знака, округление HALF_UP. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-AVAIL-001' offlineOperation : QualityRequirement {
        doc /* Полная работоспособность без подключения к интернету. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-OBS-001' fileLogging : QualityRequirement {
        doc /* Файловый журнал с ротацией и без записи финансовых данных. */
        
        attribute :>> priority = Priority::should;
      }
    }
    
    package Constraints {
      requirement 'REQ-COMP-001' openSourceLicenses : DesignConstraintRequirement {
        doc /* Только открытые лицензии; список в THIRD-PARTY-LICENSES. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-COMP-002' isoDataFormats : DesignConstraintRequirement {
        doc /* Даты по ISO 8601, коды валют по ISO 4217. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-INST-001' localInstallation : DesignConstraintRequirement {
        doc /* Запуск из JAR или jpackage без прав администратора; данные в каталоге пользователя. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-BUILD-001' reproducibleBuild : DesignConstraintRequirement {
        doc /* Сборка одной командой mvn package, зафиксированные версии, тесты в составе сборки. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-BUILD-002' continuousIntegration : DesignConstraintRequirement {
        doc /* Автоматическая сборка и тесты в GitHub Actions. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-DIST-001' singleProcess : DesignConstraintRequirement {
        doc /* Единый локальный процесс без сетевого взаимодействия компонентов. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-MAINT-001' layeredArchitecture : DesignConstraintRequirement {
        doc /* Слои: представление, сервисы, репозитории; расчёты только в сервисах. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-MAINT-002' testCoverage : DesignConstraintRequirement {
        doc /* Покрытие модульными тестами сервисного слоя не менее 70 %. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-MAINT-003' codeStyle : DesignConstraintRequirement {
        doc /* Единый стиль кода (Checkstyle) и Javadoc сервисного слоя. */
        
        attribute :>> priority = Priority::could;
      }
      
      requirement 'REQ-REUSE-001' uiIndependentLogic : DesignConstraintRequirement {
        doc /* Бизнес-логика в отдельном модуле без зависимости от JavaFX. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-PORT-001' supportedPlatforms : DesignConstraintRequirement {
        doc /* Windows 10+, macOS 12+, Ubuntu 22.04+ при наличии Java 17+. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-PORT-002' environmentIndependence : DesignConstraintRequirement {
        doc /* Пути через user.home, без жёстко заданных абсолютных путей. */
        
        attribute :>> priority = Priority::should;
      }
      
      requirement 'REQ-COST-001' zeroLicenseCost : DesignConstraintRequirement {
        doc /* Разработка и эксплуатация без платных лицензий. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-DEAD-001' releaseDeadline : DesignConstraintRequirement {
        doc /* Версия 1.0 (все Must) к согласованной дате; дата TBD, приоритет в SRS не задан. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-POC-001' technologyPrototype : DesignConstraintRequirement {
        doc /* Прототип JavaFX + SQLite подтверждает целевые показатели PERF-002 и PERF-003. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-CM-001' semanticVersioning : DesignConstraintRequirement {
        doc /* Semantic Versioning и CHANGELOG.md. */
        
        attribute :>> priority = Priority::must;
      }
      
      requirement 'REQ-CM-002' schemaMigrations : DesignConstraintRequirement {
        doc /* Версионирование схемы БД и миграции с предварительной резервной копией. */
        
        attribute :>> priority = Priority::should;
      }
    }
  }
  
  package Structure {
    private import ScalarValues::*;
    private import Domain::*;
    
    port def RepositoryPort {
      doc /* Контракт «сервис -> репозиторий» (REQ-INT-006). */
      
      out item query : DataQuery;
      
      in item result : DataResult;
    }
    
    port def JdbcPort {
      doc /* Контракт «репозиторий -> SQLite» через JDBC. */
      
      out item statement : SqlStatement;
      
      in item rows : SqlResult;
    }
    
    port def CsvPort {
      doc /* Файловый интерфейс импорта/экспорта (REQ-INT-007). */
      
      in item importFile : CsvFile;
      
      out item exportFile : CsvFile;
    }
    
    part def User {
      doc /* Владелец бюджета: единственный класс пользователей версии 1.0. */
    }
    
    part def FileSystem {
      doc /* Локальная файловая система: CSV-файлы, резервные копии, файл БД, журналы. */
      
      port csv;
    }
    
    part def JavaRuntime {
      doc /* Среда выполнения Java 17+ (CON-01, допущение A1). */
      
      attribute version : String = "17+";
    }
    
    part def OverviewView;
    
    part def TransactionsView;
    
    part def AccountsView;
    
    part def CategoriesView;
    
    part def BudgetView;
    
    part def ReportsView;
    
    part def SettingsView;
    
    part def TransactionDialog;
    
    part def PresentationLayer {
      doc /* Слой представления: только отображение и ввод, без бизнес-расчётов (REQ-MAINT-001). */
      
      part overviewView : OverviewView;
      
      part transactionsView : TransactionsView;
      
      part accountsView : AccountsView;
      
      part categoriesView : CategoriesView;
      
      part budgetView : BudgetView;
      
      part reportsView : ReportsView;
      
      part settingsView : SettingsView;
      
      part transactionDialog : TransactionDialog;
    }
    
    part def AccountService {
      port accountRepo : RepositoryPort;
      
      port transactionRepo : RepositoryPort;
    }
    
    part def TransactionService {
      port transactionRepo : RepositoryPort;
    }
    
    part def CategoryService {
      port categoryRepo : RepositoryPort;
    }
    
    part def CategoryRuleEngine {
      doc /* Детерминированные правила автокатегоризации; ML не используется (3.6 SRS). */
      
      port ruleRepo : RepositoryPort;
    }
    
    part def BudgetService {
      port budgetRepo : RepositoryPort;
      
      port transactionRepo : RepositoryPort;
    }
    
    part def ReportService {
      port transactionRepo : RepositoryPort;
    }
    
    part def CsvService {
      port transactionRepo : RepositoryPort;
      
      port files : CsvPort;
    }
    
    part def BackupService {
      doc /* Резервное копирование, восстановление и реакция на повреждение БД. */
      
      port backupFiles : CsvPort;
    }
    
    part def SettingsService {
      port settingsRepo : RepositoryPort;
    }
    
    part def ServiceLayer {
      doc /* Слой бизнес-логики: расчёты баланса, бюджета и агрегаций (REQ-MAINT-001, REQ-REUSE-001). */
      
      part accountService : AccountService;
      
      part transactionService : TransactionService;
      
      part categoryService : CategoryService;
      
      part ruleEngine : CategoryRuleEngine;
      
      part budgetService : BudgetService;
      
      part reportService : ReportService;
      
      part csvService : CsvService;
      
      part backupService : BackupService;
      
      part settingsService : SettingsService;
    }
    
    part def AccountRepository {
      port api;
      
      port jdbc : JdbcPort;
    }
    
    part def TransactionRepository {
      port api;
      
      port jdbc : JdbcPort;
    }
    
    part def CategoryRepository {
      port api;
      
      port jdbc : JdbcPort;
    }
    
    part def BudgetRepository {
      port api;
      
      port jdbc : JdbcPort;
    }
    
    part def RuleRepository {
      port api;
      
      port jdbc : JdbcPort;
    }
    
    part def SettingsRepository {
      port api;
      
      port jdbc : JdbcPort;
    }
    
    part def SqliteDatabase {
      doc /* Встроенная БД SQLite, один файл (CON-03). Схема версионируется (REQ-CM-002). */
      
      attribute fileName : String = "finance-tracker.db";
      
      attribute schemaVersion : Integer;
      
      port jdbc;
    }
    
    part def PersistenceLayer {
      doc /* Слой доступа к данным: репозитории и БД; все запросы параметризованы (REQ-SEC-003). */
      
      connect accountRepository.jdbc to database.jdbc;
      connect transactionRepository.jdbc to database.jdbc;
      connect categoryRepository.jdbc to database.jdbc;
      connect budgetRepository.jdbc to database.jdbc;
      connect ruleRepository.jdbc to database.jdbc;
      connect settingsRepository.jdbc to database.jdbc;
      
      part accountRepository : AccountRepository;
      
      part transactionRepository : TransactionRepository;
      
      part categoryRepository : CategoryRepository;
      
      part budgetRepository : BudgetRepository;
      
      part ruleRepository : RuleRepository;
      
      part settingsRepository : SettingsRepository;
      
      part database : SqliteDatabase;
    }
    
    part def FinanceTrackerSystem {
      doc /* Автономное настольное приложение «Трекер финансов»: один процесс, без сети (REQ-DIST-001, REQ-AVAIL-001). */
      
      connect services.accountService.accountRepo to persistence.accountRepository.api;
      connect services.accountService.transactionRepo to persistence.transactionRepository.api;
      connect services.transactionService.transactionRepo to persistence.transactionRepository.api;
      connect services.categoryService.categoryRepo to persistence.categoryRepository.api;
      connect services.ruleEngine.ruleRepo to persistence.ruleRepository.api;
      connect services.budgetService.budgetRepo to persistence.budgetRepository.api;
      connect services.budgetService.transactionRepo to persistence.transactionRepository.api;
      connect services.reportService.transactionRepo to persistence.transactionRepository.api;
      connect services.csvService.transactionRepo to persistence.transactionRepository.api;
      connect services.settingsService.settingsRepo to persistence.settingsRepository.api;
      
      attribute version : String = "1.0";
      
      attribute startupTimeLimitSec : Real = 3;
      
      attribute viewResponseLimitSec : Real = 1;
      
      attribute memoryLimitMb : Integer = 300;
      
      part presentation : PresentationLayer;
      
      part services : ServiceLayer;
      
      part persistence : PersistenceLayer;
    }
    
    part def FinanceTrackerContext {
      connect tracker.services.csvService.files to fileSystem.csv;
      
      part user : User;
      
      part tracker : FinanceTrackerSystem;
      
      part fileSystem : FileSystem;
      
      part runtime : JavaRuntime;
    }
    
    part financeTrackerContext : FinanceTrackerContext;
  }
  
  package Calculations {
    private import ScalarValues::*;
    
    calc def AccountBalance {
      doc /* REQ-FUNC-002: баланс = начальный + доходы - расходы + входящие переводы - исходящие. */
      
      initialBalance + incomes - expenses + transfersIn - transfersOut;
      in initialBalance : Real;
      in incomes : Real;
      in expenses : Real;
      in transfersIn : Real;
      in transfersOut : Real;
      return result : Real;
    }
    
    calc def ExecutionPercent {
      doc /* REQ-FUNC-013: процент исполнения = факт / план * 100 (факт — только расходы, без переводов). */
      
      fact / plan * 100;
      in fact : Real;
      in plan : Real;
      return result : Real;
    }
    
    constraint def NormalRange {
      percent < 80;
      in percent : Real;
    }
    
    constraint def WarningRange {
      percent >= 80 and percent < 100;
      in percent : Real;
    }
    
    constraint def ExceededRange {
      percent >= 100;
      in percent : Real;
    }
    
    constraint def PositiveAmount {
      doc /* REQ-INT-002, приложение B SRS: сумма операции строго положительна. */
      
      amount > 0;
      in amount : Real;
    }
    
    constraint def MonthStartDayRange {
      doc /* REQ-FUNC-023: расчётный день месяца 1..28. */
      
      day >= 1 and day <= 28;
      in day : Integer;
    }
  }
  
  package Behavior {
    private import Domain::*;
    
    action def ValidateDraft {
      doc /* Проверка суммы, даты, счёта; при ошибке сообщение у поля и отказ от сохранения (REQ-INT-002). */
      
      in item draft : TransactionDraft;
    }
    
    action def ApplyCategorizationRules {
      doc /* Если категория не выбрана — применить первое подходящее правило, иначе «Прочее» (REQ-FUNC-011). */
      
      in item draft : TransactionDraft;
    }
    
    action def PersistTransaction {
      doc /* Сохранить операцию в транзакции БД (REQ-REL-001). */
      
      in item draft : TransactionDraft;
    }
    
    action def RecalculateBalances {
      doc /* Пересчитать баланс счёта и суммарный баланс (REQ-FUNC-002). */
    }
    
    action def UpdateBudgetIndicators {
      doc /* Пересчитать % исполнения и статус бюджета затронутой категории (REQ-FUNC-013). */
    }
    
    action def RefreshViews {
      doc /* Обновить список, диаграммы и индикаторы не позднее чем через 1 с (REQ-FUNC-019). */
    }
    
    action def AddTransactionFlow {
      first start;
      then done;
      
      in item draft : TransactionDraft;
      
      then action validate : ValidateDraft;
      
      then action categorize : ApplyCategorizationRules;
      
      then action persist : PersistTransaction;
      
      then action recalc : RecalculateBalances;
      
      then action budget : UpdateBudgetIndicators;
      
      then action refresh : RefreshViews;
    }
    
    action def SelectMonth;
    
    action def ComputeExecution {
      doc /* План, факт, остаток и процент по каждой категории месяца. */
    }
    
    action def ClassifyStatus {
      doc /* normal < 80 %; warning 80–99 %; exceeded >= 100 %. */
    }
    
    action def HighlightCategories {
      doc /* Значок и текст статуса, а не только цвет (REQ-INT-004). */
    }
    
    action def CheckBudgetFlow {
      first start;
      then done;
      
      then action select : SelectMonth;
      
      then action compute : ComputeExecution;
      
      then action classify : ClassifyStatus;
      
      then action highlight : HighlightCategories;
    }
    
    action def SelectPeriod;
    
    action def AggregateExpenses;
    
    action def AggregateIncomeExpenseByMonth;
    
    action def RenderCharts;
    
    action def AnalyzeExpensesFlow {
      first start;
      then done;
      
      then action select : SelectPeriod;
      
      then action byCategory : AggregateExpenses;
      
      then action byMonth : AggregateIncomeExpenseByMonth;
      
      then action render : RenderCharts;
    }
    
    action def ReadCsv {
      in item file : CsvFile;
    }
    
    action def PreviewImport {
      doc /* Предпросмотр и число строк с ошибками до подтверждения. */
    }
    
    action def ConfirmImport;
    
    action def ImportValidRows {
      doc /* Импортируются корректные строки; новые счета и категории — только с подтверждением. */
    }
    
    action def ShowImportReport {
      doc /* Номера и причины пропущенных строк. */
    }
    
    action def ImportCsvFlow {
      first start;
      then done;
      
      in item file : CsvFile;
      
      then action read : ReadCsv;
      
      then action preview : PreviewImport;
      
      then action confirm : ConfirmImport;
      
      then action importRows : ImportValidRows;
      
      then action report : ShowImportReport;
    }
  }
  
  package UseCases {
    private import Structure::*;
    
    use case def AddExpense {
      doc /* UC-1. Альтернативный поток: некорректная сумма -> сообщение у поля, операция не сохраняется. */
      
      subject tracker : FinanceTrackerSystem;
      
      actor user : User;
      
      objective {
        doc /* Пользователь фиксирует расход; баланс, диаграммы и бюджет обновляются. */
      }
    }
    
    use case def CheckBudget {
      doc /* UC-2. */
      
      subject tracker : FinanceTrackerSystem;
      
      actor user : User;
      
      objective {
        doc /* Пользователь видит план, факт, остаток и статус по каждой категории месяца. */
      }
    }
    
    use case def AnalyzeExpenses {
      doc /* UC-3. */
      
      subject tracker : FinanceTrackerSystem;
      
      actor user : User;
      
      objective {
        doc /* Пользователь анализирует структуру и динамику трат за период. */
      }
    }
    
    use case def ImportHistory {
      doc /* UC-4. */
      
      subject tracker : FinanceTrackerSystem;
      
      actor user : User;
      
      actor files : FileSystem;
      
      objective {
        doc /* Пользователь переносит накопленную историю из CSV. */
      }
    }
    
    use case def ManageAccountsAndCategories {
      doc /* Поддерживающий вариант использования (REQ-FUNC-001, 003, 009, 010). */
      
      subject tracker : FinanceTrackerSystem;
      
      actor user : User;
      
      objective {
        doc /* Пользователь настраивает счета, категории и правила автокатегоризации. */
      }
    }
    
    use case addExpense : AddExpense;
    
    use case checkBudget : CheckBudget;
    
    use case analyzeExpenses : AnalyzeExpenses;
    
    use case importHistory : ImportHistory;
    
    use case manageAccountsAndCategories : ManageAccountsAndCategories;
  }
  
  package States {
    private import ScalarValues::*;
    
    item def BudgetRecalculated {
      attribute percent : Real;
    }
    
    state def BudgetExecutionState {
      doc /* Статус исполнения бюджета категории (REQ-FUNC-013): 79 % — normal, 80 % и 99 % — warning, 100 % и выше — exceeded. */
      
      entry; then normal;
      transition
        first normal
        accept e1:BudgetRecalculated
        if e1.percent >= 80 and e1.percent < 100
        then warning;
      transition
        first normal
        accept e2:BudgetRecalculated
        if e2.percent >= 100
        then exceeded;
      transition
        first warning
        accept e3:BudgetRecalculated
        if e3.percent >= 100
        then exceeded;
      transition
        first warning
        accept e4:BudgetRecalculated
        if e4.percent < 80
        then normal;
      transition
        first exceeded
        accept e5:BudgetRecalculated
        if e5.percent >= 80 and e5.percent < 100
        then warning;
      transition
        first exceeded
        accept e6:BudgetRecalculated
        if e6.percent < 80
        then normal;
      
      state normal;
      
      state warning;
      
      state exceeded;
    }
    
    item def DatabaseOpened;
    
    item def DatabaseUnavailable;
    
    item def RecoveryChosen;
    
    item def CloseRequested;
    
    state def ApplicationLifecycle {
      doc /* Жизненный цикл приложения; повреждение БД не приводит к аварийному завершению (REQ-REL-002). */
      
      entry; then starting;
      transition
        first starting
        accept opened:DatabaseOpened
        then running;
      transition
        first starting
        accept missing:DatabaseUnavailable
        then databaseError;
      transition
        first databaseError
        accept recovered:RecoveryChosen
        then running;
      transition
        first databaseError
        accept closeOnError:CloseRequested
        then closing;
      transition
        first running
        accept close:CloseRequested
        then closing;
      
      state starting;
      
      state databaseError;
      
      state running;
      
      state closing;
    }
  }
  
  package Verification {
    verification def AccountBalanceTest {
      doc /* Test. 20 операций, эталонные балансы с точностью до копейки. */
      
      objective {
        verify FinanceTrackerModel::Requirements::Functional::balanceCalculation;
      }
    }
    
    verification def AutoCategorizationTest {
      doc /* Test. Правило «магнит -> Продукты», регистронезависимо; без совпадений — «Прочее». */
      
      objective {
        verify FinanceTrackerModel::Requirements::Functional::autoCategorization;
      }
    }
    
    verification def BudgetThresholdTest {
      doc /* Test. Границы 79 / 80 / 99 / 100 / 101 %. */
      
      objective {
        verify FinanceTrackerModel::Requirements::Functional::budgetExecutionControl;
        verify FinanceTrackerModel::Requirements::Functional::monthlyCategoryLimits;
      }
    }
    
    verification def CsvRoundTripTest {
      doc /* Test. Экспорт -> импорт даёт идентичный набор операций; импорт файла с ошибочными строками. */
      
      objective {
        verify FinanceTrackerModel::Requirements::Interfaces::csvFormat;
        verify FinanceTrackerModel::Requirements::Functional::csvExport;
        verify FinanceTrackerModel::Requirements::Functional::csvImport;
      }
    }
    
    verification def MoneyRoundingTest {
      doc /* Test. 1000 операций по 0,10 дают ровно 100,00. */
      
      objective {
        verify FinanceTrackerModel::Requirements::Quality::moneyArithmeticCorrectness;
      }
    }
    
    verification def SqlInjectionTest {
      doc /* Test. Описание с SQL-фрагментом сохраняется как текст; фаззинг CSV. */
      
      objective {
        verify FinanceTrackerModel::Requirements::Quality::inputValidationParametrizedSql;
      }
    }
    
    verification def CrashRecoveryTest {
      doc /* Test. Принудительное завершение процесса сразу после сохранения. */
      
      objective {
        verify FinanceTrackerModel::Requirements::Quality::transactionalWrites;
      }
    }
    
    verification def CorruptedDbStartupTest {
      doc /* Test. Запуск с повреждённым файлом БД. */
      
      objective {
        verify FinanceTrackerModel::Requirements::Quality::corruptedDbHandling;
      }
    }
    
    verification def StartupBenchmark {
      doc /* Test. 95-й процентиль по 20 замерам <= 3 с на БД из 10 000 операций. */
      
      objective {
        verify FinanceTrackerModel::Requirements::Quality::startupTime;
      }
    }
    
    verification def ListAndChartBenchmark {
      doc /* Test. Список/фильтр/сортировка и построение диаграмм <= 1 с. */
      
      objective {
        verify FinanceTrackerModel::Requirements::Quality::listResponseTime;
        verify FinanceTrackerModel::Requirements::Quality::chartRenderTime;
      }
    }
    
    verification def NetworkCaptureAnalysis {
      doc /* Analysis. Отсутствие исходящих соединений при полном сценарии использования. */
      
      objective {
        verify FinanceTrackerModel::Requirements::Quality::localOnlyNoTelemetry;
        verify FinanceTrackerModel::Requirements::Quality::offlineOperation;
        verify FinanceTrackerModel::Requirements::Constraints::singleProcess;
      }
    }
    
    verification def MigrationTest {
      doc /* Test. БД предыдущего релиза открывается новой версией без потерь. */
      
      objective {
        verify FinanceTrackerModel::Requirements::Constraints::schemaMigrations;
      }
    }
  }
  
  package Allocation {
    satisfy Requirements::Interfaces::mainWindowStructure by Structure::financeTrackerContext.tracker.presentation;
    satisfy Requirements::Interfaces::transactionFormValidation by Structure::financeTrackerContext.tracker.presentation.transactionDialog;
    satisfy Requirements::Interfaces::uiLocalization by Structure::financeTrackerContext.tracker.presentation;
    satisfy Requirements::Interfaces::uiAccessibility by Structure::financeTrackerContext.tracker.presentation;
    satisfy Requirements::Interfaces::minimumResolution by Structure::financeTrackerContext.tracker.presentation;
    satisfy Requirements::Interfaces::databaseAccessInterface by Structure::financeTrackerContext.tracker.persistence;
    satisfy Requirements::Interfaces::csvFormat by Structure::financeTrackerContext.tracker.services.csvService;
    satisfy Requirements::Functional::accountCreateEdit by Structure::financeTrackerContext.tracker.services.accountService;
    satisfy Requirements::Functional::balanceCalculation by Structure::financeTrackerContext.tracker.services.accountService;
    satisfy Requirements::Functional::accountArchiving by Structure::financeTrackerContext.tracker.services.accountService;
    satisfy Requirements::Functional::addIncomeExpense by Structure::financeTrackerContext.tracker.services.transactionService;
    satisfy Requirements::Functional::editDeleteTransaction by Structure::financeTrackerContext.tracker.services.transactionService;
    satisfy Requirements::Functional::transactionListFilter by Structure::financeTrackerContext.tracker.services.transactionService;
    satisfy Requirements::Functional::transfersBetweenAccounts by Structure::financeTrackerContext.tracker.services.transactionService;
    satisfy Requirements::Functional::recurringTransactions by Structure::financeTrackerContext.tracker.services.transactionService;
    satisfy Requirements::Functional::defaultCategories by Structure::financeTrackerContext.tracker.services.categoryService;
    satisfy Requirements::Functional::categoryManagement by Structure::financeTrackerContext.tracker.services.categoryService;
    satisfy Requirements::Functional::autoCategorization by Structure::financeTrackerContext.tracker.services.ruleEngine;
    satisfy Requirements::Functional::monthlyCategoryLimits by Structure::financeTrackerContext.tracker.services.budgetService;
    satisfy Requirements::Functional::budgetExecutionControl by Structure::financeTrackerContext.tracker.services.budgetService;
    satisfy Requirements::Functional::totalLimitAndCopyBudget by Structure::financeTrackerContext.tracker.services.budgetService;
    satisfy Requirements::Functional::expensePieChart by Structure::financeTrackerContext.tracker.services.reportService;
    satisfy Requirements::Functional::incomeExpenseBarChart by Structure::financeTrackerContext.tracker.services.reportService;
    satisfy Requirements::Functional::balanceDynamicsChart by Structure::financeTrackerContext.tracker.services.reportService;
    satisfy Requirements::Functional::overviewScreen by Structure::financeTrackerContext.tracker.presentation.overviewView;
    satisfy Requirements::Functional::liveViewRefresh by Structure::financeTrackerContext.tracker.presentation;
    satisfy Requirements::Functional::csvExport by Structure::financeTrackerContext.tracker.services.csvService;
    satisfy Requirements::Functional::csvImport by Structure::financeTrackerContext.tracker.services.csvService;
    satisfy Requirements::Functional::backupRestore by Structure::financeTrackerContext.tracker.services.backupService;
    satisfy Requirements::Functional::appSettings by Structure::financeTrackerContext.tracker.services.settingsService;
    satisfy Requirements::Quality::startupTime by Structure::financeTrackerContext.tracker;
    satisfy Requirements::Quality::listResponseTime by Structure::financeTrackerContext.tracker.services.transactionService;
    satisfy Requirements::Quality::chartRenderTime by Structure::financeTrackerContext.tracker.services.reportService;
    satisfy Requirements::Quality::memoryFootprint by Structure::financeTrackerContext.tracker;
    satisfy Requirements::Quality::localOnlyNoTelemetry by Structure::financeTrackerContext.tracker;
    satisfy Requirements::Quality::pinProtection by Structure::financeTrackerContext.tracker.services.settingsService;
    satisfy Requirements::Quality::inputValidationParametrizedSql by Structure::financeTrackerContext.tracker.persistence;
    satisfy Requirements::Quality::transactionalWrites by Structure::financeTrackerContext.tracker.persistence;
    satisfy Requirements::Quality::corruptedDbHandling by Structure::financeTrackerContext.tracker.services.backupService;
    satisfy Requirements::Quality::moneyArithmeticCorrectness by Structure::financeTrackerContext.tracker.services;
    satisfy Requirements::Quality::offlineOperation by Structure::financeTrackerContext.tracker;
    satisfy Requirements::Quality::fileLogging by Structure::financeTrackerContext.tracker;
    satisfy Requirements::Constraints::isoDataFormats by Structure::financeTrackerContext.tracker;
    satisfy Requirements::Constraints::localInstallation by Structure::financeTrackerContext.tracker;
    satisfy Requirements::Constraints::singleProcess by Structure::financeTrackerContext.tracker;
    satisfy Requirements::Constraints::layeredArchitecture by Structure::financeTrackerContext.tracker;
    satisfy Requirements::Constraints::uiIndependentLogic by Structure::financeTrackerContext.tracker.services;
    satisfy Requirements::Constraints::supportedPlatforms by Structure::financeTrackerContext.tracker;
    satisfy Requirements::Constraints::environmentIndependence by Structure::financeTrackerContext.tracker;
    satisfy Requirements::Constraints::schemaMigrations by Structure::financeTrackerContext.tracker.persistence;
  }
}
