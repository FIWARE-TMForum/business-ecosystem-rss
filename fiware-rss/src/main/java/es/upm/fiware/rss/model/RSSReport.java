/**
 * Copyright (C) 2015 CoNWeT Lab., Universidad Politécnica de Madrid
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

package es.upm.fiware.rss.model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class RSSReport {

	private int id;
    private String ownerProviderId;
    private BigDecimal ownerValue;
    private String productClass;
    private String algorithmType;
    private String aggregatorId;
    private BigDecimal aggregatorValue;
    private Date timestamp;
    private String currency;
    private List<StakeholderModel> stakeholders;


    private boolean paid;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

    public String getOwnerProviderId() {
        return ownerProviderId;
    }

    public void setOwnerProviderId(String ownerProviderId) {
        this.ownerProviderId = ownerProviderId;
    }

    public String getProductClass() {
        return productClass;
    }

    public BigDecimal getOwnerValue() {
        return ownerValue;
    }

    public void setOwnerValue(BigDecimal ownerValue) {
        this.ownerValue = ownerValue;
    }

    public void setProductClass(String productClass) {
        this.productClass = productClass;
    }

    public String getAlgorithmType() {
        return algorithmType;
    }

    public void setAlgorithmType(String algorithmType) {
        this.algorithmType = algorithmType;
    }

    public String getAggregatorId() {
        return aggregatorId;
    }

    public void setAggregatorId(String aggregatorId) {
        this.aggregatorId = aggregatorId;
    }

    public BigDecimal getAggregatorValue() {
        return aggregatorValue;
    }

    public void setAggregatorValue(BigDecimal aggregatorValue) {
        this.aggregatorValue = aggregatorValue;
    }

    public List<StakeholderModel> getStakeholders() {
        return stakeholders;
    }

    public void setStakeholders(List<StakeholderModel> stakeholders) {
        this.stakeholders = stakeholders;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public boolean getPaid() { return paid; }

    public void setPaid(boolean paid) { this.paid = paid; }
}
