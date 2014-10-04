import ceylon.interop.java {
    javaClass
}
import ceylon.transaction.datasource {
    bindDataSources
}

import com.arjuna.ats.arjuna.common {
    \IrecoveryPropertyManager {
        recoveryEnvironmentBean
    }
}
import com.arjuna.ats.arjuna.logging {
    \ItsLogger {
        logger
    }
}
import com.arjuna.ats.arjuna.recovery {
    RecoveryModule,
    RecoveryManager
}
import com.arjuna.ats.internal.arjuna.recovery {
    AtomicActionRecoveryModule
}
import com.arjuna.ats.internal.jta.recovery.arjunacore {
    XARecoveryModule
}
import com.arjuna.ats.jdbc {
    TransactionalDriver
}
import com.arjuna.ats.jdbc.common {
    \IjdbcPropertyManager {
        jdbcEnvironmentBean
    }
}

import java.lang {
    Runtime,
    Thread
}
import java.sql {
    DriverManager
}
import java.util {
    Arrays
}

import javax.transaction {
    JavaTransactionManager=TransactionManager,
    UserTransaction,
    Status {
        status_no_transaction=STATUS_NO_TRANSACTION
    }
}

class ConcreteTransactionManager() satisfies TransactionManager {

    shared NamingServer jndiServer = NamingServer();
    
    shared actual variable JavaTransactionManager? transactionManager = null;
    
    variable UserTransaction? userTransaction = null;
    
    "Start the transaction service."
    throws(`class Exception`, 
        "if no JNDI InitialContext is available")
    shared actual void start(
            "If `true`, an in-process recovery service is started."
            Boolean startRecoveryService) {
        jndiServer.start();
        if (exists dataSourceConfigPropertyFile 
            = process.propertyValue("dbc.properties")) {
            bindDataSources(dataSourceConfigPropertyFile);
        }
        else {
            bindDataSources();
        }

        if (!initialized) {
            try {
                Thread.currentThread().contextClassLoader 
                        = javaClass<TransactionManager>().classLoader;
                
                replacedJndiProperties 
                        = jdbcEnvironmentBean.jndiProperties.empty;
                if (replacedJndiProperties) {
                    jdbcEnvironmentBean.jndiProperties 
                            = initialContext.environment;
                }
                
                DriverManager.registerDriver(TransactionalDriver());
            } catch (Exception e) {
                if (logger.infoEnabled) {
                    logger.info("TransactionServiceFactory error:", e);
                }
                throw Exception("No suitable JNDI provider available", e);
            }
            registerTransactionManagerJndiBindings(initialContext);
            
            initialized = true;
            
            if (startRecoveryService) {
                if (!recoveryManager exists) {
                    recoveryEnvironmentBean.recoveryModules 
                            = Arrays.asList<RecoveryModule>
                            (AtomicActionRecoveryModule(), XARecoveryModule());
                    value rm = RecoveryManager.manager();
                    rm.initialize();
                    recoveryManager = rm;
                }
            }
            
            object thread extends Thread() {
                run() => stop();
            }
            Runtime.runtime.addShutdownHook(thread);
            
        }
        
        if (is UserTransaction ut 
            = jndiServer.lookup("java:/UserTransaction")) {
            userTransaction = ut;
        }
        if (is JavaTransactionManager tm 
            = jndiServer.lookup("java:/TransactionManager")) {
            transactionManager = tm;
        } else {
            print("java:/TransactionManager lookup failed");
        }
    }

    "Stop the transaction service. If an in-process recovery 
     manager is running, then it to will be stopped."
    shared actual void stop() {
        if (initialized) {
            recoveryManager?.terminate();
            recoveryManager = null;
            
            unregisterTransactionManagerJndiBindings();
            
            try {
                DriverManager.deregisterDriver(TransactionalDriver());
            }
            catch (Exception e) {
                if (logger.infoEnabled) {
                    logger.debug("Unable to deregister TransactionalDriver: " 
                        + e.message, e);
                }
            }
            
            if (replacedJndiProperties) {
                jdbcEnvironmentBean.jndiProperties = null;
            }
            
            initialized = false;
        }
        
        userTransaction = null;
        transactionManager = null;
    }
    
    recoveryScan() => recoveryManager?.scan();

    shared actual UserTransaction? beginTransaction() {
        if (is UserTransaction ut = userTransaction) {
            ut.begin();
            return ut;
        }
        return null;
    }

    shared actual UserTransaction? currentTransaction {
        if (is UserTransaction ut = userTransaction) {
            if (ut.status != status_no_transaction) {
                return ut;
            }
        }
        return null;
    }
    
    transactionActive => currentTransaction exists;

    "Execute the passed Callable within a transaction. If any
     exception is thrown from within the Callable, the transaction will
     be rolled back; otherwise it is committed."
    shared actual Boolean transaction(Boolean do()) {
        variable value ok = false;
        if (exists transaction = beginTransaction()) {
            try {
                ok = do();
            } finally {
                try {
                    if (ok) {
                        transaction.commit();
                    } else {
                        transaction.rollback();
                    }
                } catch (Exception e) {
                    ok = false;
                }
            }
        }

        return ok;
    }
}

variable RecoveryManager? recoveryManager = null;
variable Boolean initialized = false;
variable Boolean replacedJndiProperties = false;

ConcreteTransactionManager concreteTransactionManager 
        = ConcreteTransactionManager();
