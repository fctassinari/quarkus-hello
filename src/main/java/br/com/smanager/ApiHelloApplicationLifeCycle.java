package br.com.smanager;


import io.quarkus.runtime.ShutdownEvent;
import io.quarkus.runtime.StartupEvent;
import io.quarkus.runtime.configuration.ConfigUtils;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Observes;
import org.jboss.logging.Logger;

@ApplicationScoped
public class ApiHelloApplicationLifeCycle {

    private static final Logger LOGGER = Logger.getLogger(ApiHelloApplicationLifeCycle.class);

    //https://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20
    void onStart(@Observes StartupEvent ev) {
        LOGGER.info("The application Hello is starting with profile " + ConfigUtils.getProfiles());
    }

    void onStop(@Observes ShutdownEvent ev) {
        LOGGER.info("The application Hello is stopping...");
    }
}