# iso19139.gdpr

The European General Data Protection Regulation recommends to set up a registry to capture for each dataset containing sensitive personal data details about the treatment of the dataset. This profile extends the ISO 19139 schema to facilitate to capture typical GDPR metadata elements, that do not fit in any of the ISO 19139 fields.


## Installing the plugin

### GeoNetwork version to use with this plugin

Use GeoNetwork 3.10+. It's not supported in older versions so don't plug it into it!

### Adding the plugin to the source code

The best approach is to add the plugin as a submodule into GeoNetwork schema module.

```
cd schemas
git submodule add -b 3.10.x https://github.com/metadata101/iso19139.gdpr iso19139.gdpr
```

Add the new module to the schema/pom.xml:

```
  <module>iso19139</module>
  <module>iso19139.gdpr</module>
</modules>
```

Add the dependency in the web module in web/pom.xml:

```
<dependency>
  <groupId>${project.groupId}</groupId>
  <artifactId>schema-iso19139.gdpr</artifactId>
  <version>${gn.schemas.version}</version>
</dependency>
```

Add the module to the webapp in web/pom.xml:

```
<execution>
  <id>copy-schemas</id>
  <phase>process-resources</phase>
  ...
  <resource>
    <directory>${project.basedir}/../schemas/iso19139.gdpr/src/main/plugin</directory>
    <targetPath>${basedir}/src/main/webapp/WEB-INF/data/config/schema_plugins</targetPath>
  </resource>
```

### Adding editor configuration

Editor configuration in GeoNetwork 3.10.x is done in `schemas/iso19139.gdpr/src/main/plugin/iso19139.gdpr/layout/config-editor.xml` inside each view. Default values are the following:

      <sidePanel>
        <directive data-gn-onlinesrc-list=""/>
        <directive gn-geo-publisher=""
                   data-ng-if="gnCurrentEdit.geoPublisherConfig"
                   data-config="{{gnCurrentEdit.geoPublisherConfig}}"
                   data-lang="lang"/>
        <directive data-gn-validation-report=""/>
        <directive data-gn-suggestion-list=""/>
        <directive data-gn-need-help="user-guide/describing-information/creating-metadata.html"/>
      </sidePanel>

### Build the application 

Once the application is build, the war file contains the schema plugin:

```
$ mvn clean install -Penv-prod
```

### Deploy the profile in an existing installation

After building the application, it's possible to deploy the schema plugin manually in an existing GeoNetwork installation:

- Copy the content of the folder schemas/iso19139.gdpr/src/main/plugin to INSTALL_DIR/geonetwork/WEB-INF/data/config/schema_plugins/iso19139.gdpr

- Copy the jar file schemas/iso19139.gdpr/target/schema-iso19139.gdpr-3.10.jar to INSTALL_DIR/geonetwork/WEB-INF/lib.

If there's no changes to the profile Java code or the configuration (config-spring-geonetwork.xml), the jar file is not required to be deployed each time.
