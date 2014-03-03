from nsweb import settings
from nsweb.core import app, setup_logging, create_app, register_blueprints
#registers models
import nsweb.models



def main():
    #sets up the flask app
    create_app(database_uri = settings.SQLALCHEMY_DATABASE_URI)
    
    #creates and registers blueprints in nsweb.blueprints
    import nsweb.blueprints.studies
    import nsweb.blueprints.features
    import nsweb.blueprints.images
    #loads blueprints
    register_blueprints()
    
    #sets up logging
    setup_logging(logging_path=settings.LOGGING_PATH,level=settings.LOGGING_LEVEL)
        
    # To allow aptana to receive errors, set use_debugger=False
    if app.debug: use_debugger = True
    try:
        # Disable Flask's debugger if external debugger is requested
        use_debugger = not(app.config.get('DEBUG_WITH_APTANA'))
    except:
        pass
    app.run(use_debugger=use_debugger, debug=app.debug,
            use_reloader=use_debugger)

if __name__ == "__main__":
        main()