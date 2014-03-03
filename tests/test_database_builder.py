from tests import *
import factory
#TODO: This isn't really tested without fixture =( ... will I ever use anything db specific??? prob not. Factory boy should work. Don't forget about factory logger

class Test(TestCase):

    def test_initialize_database(self):
        '''Clears and sets up tables in database. The tables in studies, features, and images should exist, but no data'''
        database_builder.init_database(self.db)
        asdf = self.db.Query.all()
        
if __name__ == "__main__":
    import nose
    nose.run()